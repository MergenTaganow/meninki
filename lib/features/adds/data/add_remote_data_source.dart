import 'package:dartz/dartz.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/features/adds/models/add.dart';

import '../../../core/failure.dart';
import '../../../core/injector.dart';
import '../../../core/success.dart';
import '../../categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import '../../global/blocs/key_filter_cubit/key_filter_cubit.dart';
import '../../province/blocks/province_selecting_cubit/province_selecting_cubit.dart';
import '../../reels/model/query.dart';

abstract class AddRemoteDataSource {
  Future<Either<Failure, Add>> createAdd(Map<String, dynamic> data);
  Future<Either<Failure, List<Add>>> getAdds(Query query);
  Future<Either<Failure, Add>> addByUUid(int id);
  Future<Either<Failure, List<int>>> getFavoriteIds();
  Future<Either<Failure, Success>> addFavoriteAdd(int productId);
  Future<Either<Failure, Success>> removeFavoriteAdd(int productId);
}

class AddRemoteDataSourceImpl extends AddRemoteDataSource {
  final Api api;
  AddRemoteDataSourceImpl(this.api);

  @override
  Future<Either<Failure, Add>> createAdd(Map<String, dynamic> data) async {
    // try {
    print(data);
      var response = await api.dio.post('v1/advertisements', data: data);

      return Right(Add.fromJson(response.data['payload']));
    // } catch (e) {
    //   return Left(handleError(e));
    // }
  }

  @override
  Future<Either<Failure, List<Add>>> getAdds(Query query) async {
    try {
      var selectedCategories =
          sl<CategorySelectingCubit>().selectedMap[CategorySelectingCubit.adds_page_category] ?? [];
      var provinces =
          sl<ProvinceSelectingCubit>().selectedMap[ProvinceSelectingCubit.add_filter_province] ??
          [];
      var keyFilters = sl<KeyFilterCubit>().selectedMap;

      var param = {
        ...query.toMap(),
        if (selectedCategories.isNotEmpty) "category_id": selectedCategories.single.id,
        if (provinces.isNotEmpty) "province_ids": provinces.map((e) => e.id).toList(),
        if (keyFilters[KeyFilterCubit.adds_search_max_price] != null)
          "max_price": keyFilters[KeyFilterCubit.adds_search_max_price],
        if (keyFilters[KeyFilterCubit.adds_search_min_price] != null)
          "min_price": keyFilters[KeyFilterCubit.adds_search_min_price],
      };
      var response = await api.dio.get(
        'v1/${query.extraUrl ?? 'advertisements/public'}',
        queryParameters: param,
      );

      List<Add> product = (response.data['payload'] as List).map((e) => Add.fromJson(e)).toList();
      return Right(product);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Add>> addByUUid(int id) async {
    try {
      var response = await api.dio.get('v1/advertisements/public/$id');

      return Right(Add.fromJson(response.data['payload']));
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getFavoriteIds() async {
    try {
      var response = await api.dio.get('v1/saved-adds/ids');

      List<int> list = (response.data['payload'] as List).map((e) => e as int).toList();

      return Right(list);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> addFavoriteAdd(int productId) async {
    try {
      await api.dio.post('v1/saved-adds/$productId');

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> removeFavoriteAdd(int productId) async {
    try {
      await api.dio.delete('v1/saved-adds/$productId');

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }
}
