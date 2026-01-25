import 'package:dartz/dartz.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/features/adds/models/add.dart';

import '../../../core/failure.dart';
import '../../../core/injector.dart';
import '../../categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import '../../reels/model/query.dart';

abstract class AddRemoteDataSource {
  Future<Either<Failure, Add>> createAdd(Map<String, dynamic> data);
  Future<Either<Failure, List<Add>>> getAdds(Query query);
  Future<Either<Failure, Add>> addByUUid(int id);
}

class AddRemoteDataSourceImpl extends AddRemoteDataSource {
  final Api api;
  AddRemoteDataSourceImpl(this.api);

  @override
  Future<Either<Failure, Add>> createAdd(Map<String, dynamic> data) async {
    try {
      var response = await api.dio.post('v1/advertisements', data: data);

      return Right(Add.fromJson(response.data['payload']));
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<Add>>> getAdds(Query query) async {
    try {
      var selectedCategories =
          sl<CategorySelectingCubit>().selectedMap[CategorySelectingCubit.adds_page_category] ?? [];

      var param = {
        ...query.toMap(),
        if (selectedCategories.isNotEmpty) "category_id": selectedCategories.single.id,
      };
      print(param);
      var response = await api.dio.get('v1/advertisements/public', queryParameters: param);

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
}
