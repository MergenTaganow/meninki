import 'package:dartz/dartz.dart';
import 'package:meninki/core/success.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:meninki/features/store/models/market.dart';
import '../../../core/api.dart';
import '../../../core/failure.dart';

abstract class StoreRemoteDataSource {
  Future<Either<Failure, Success>> storeCreate(Map map);
  Future<Either<Failure, List<Market>>> getStores(Query query);
  Future<Either<Failure, List<Market>>> getMyStores(Query query);
  Future<Either<Failure, List<Market>>> getStoresProducts(Query query);
  Future<Either<Failure, Market>> getStoreByID(int id);
  Future<Either<Failure, List<int>>> getFavoriteMarkets();
  Future<Either<Failure, Success>> addFavoriteMarket(int id);
  Future<Either<Failure, Success>> removeFavoriteMarket(int id);
}

class StoreRemoteDataImpl extends StoreRemoteDataSource {
  final Api api;
  StoreRemoteDataImpl(this.api);

  @override
  Future<Either<Failure, Success>> storeCreate(Map map) async {
    try {
      var response = await api.dio.post('v1/market', data: map);

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Market>> getStoreByID(int id) async {
    try {
      var response = await api.dio.get('v1/market/$id', queryParameters: {"lang": "tk"});

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
    try {
      ///Todo later need to add language
      var response = await api.dio.get(
        'v1/market/product',
        queryParameters: {...query.toMap(), "order_direction": "asc"},
      );

      var list = (response.data['payload'] as List).map((e) => Market.fromJson(e)).toList();
      return Right(list);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<Market>>> getMyStores(Query query) async {
    try {
      var response = await api.dio.get('v1/market/client', queryParameters: query.toMap());

      var list = (response.data['payload'] as List).map((e) => Market.fromJson(e)).toList();
      return Right(list);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getFavoriteMarkets() async {
    try {
      var response = await api.dio.get('v1/market-favorites/clients');

      final payload = response.data['payload'];

      if (payload.isEmpty) {
        return Right([]);
      }
      if (payload is int) {
        return Right(<int>[payload]);
      }

      if (payload is List) {
        return Right(payload.map((e) => e as int).toList());
      }
      throw Exception('Unexpected payload type');
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> addFavoriteMarket(int id) async {
    try {
      print({'market_id': id});
      await api.dio.post('v1/market-favorites', data: {'market_id': id});

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> removeFavoriteMarket(int id) async {
    try {
      await api.dio.delete('v1/market-favorites', data: {'market_id': id});

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }
}
