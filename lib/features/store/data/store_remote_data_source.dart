import 'package:dartz/dartz.dart';
import 'package:meninki/core/success.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:meninki/features/store/models/market.dart';
import '../../../core/api.dart';
import '../../../core/failure.dart';

abstract class StoreRemoteDataSource {
  Future<Either<Failure, Success>> storeCreate(Map map);
  Future<Either<Failure, List<Market>>> getStores(Query query);
  Future<Either<Failure, List<Market>>> getStoresProducts(Query query);
  Future<Either<Failure, Market>> getStoreByID(int id);
}

class StoreRemoteDataImpl extends StoreRemoteDataSource {
  final Api api;
  StoreRemoteDataImpl(this.api);

  @override
  Future<Either<Failure, Success>> storeCreate(Map map) async {
    try {
      print(map);
      var response = await api.dio.post('v1/market', data: map);

      print(response.data);
      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Market>> getStoreByID(int id) async {
    try {
      var response = await api.dio.get('v1/market/$id', queryParameters: {"lang": "tk"});

      print(response.data);
      return Right(Market.fromJson(response.data['payload']));
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<Market>>> getStores(Query query) async {
    try {
      var response = await api.dio.get(
        'v1/market',
        queryParameters: {...query.toMap(), "order_direction": "asc", "lang": "tk"},
      );

      var list = (response.data['payload'] as List).map((e) => Market.fromJson(e)).toList();
      return Right(list);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<Market>>> getStoresProducts(Query query) async {
    // try {
    ///Todo later need to add language
    print({...query.toMap(), "order_direction": "asc"});
    var response = await api.dio.get(
      'v1/market/product',
      queryParameters: {...query.toMap(), "order_direction": "asc"},
    );

    print(response.data);
    var list = (response.data['payload'] as List).map((e) => Market.fromJson(e)).toList();
    print(list.length);
    return Right(list);
    // } catch (e) {
    //   return Left(handleError(e));
    // }
  }
}
