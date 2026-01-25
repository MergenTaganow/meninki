import 'package:dartz/dartz.dart';

import '../../../core/api.dart';
import '../../../core/failure.dart';
import '../../../core/success.dart';
import '../models/basket_product.dart';

abstract class BasketRemoteDataSource {
  Future<Either<Failure, List<int>>> getMyBasketProductIds();
  Future<Either<Failure, Success>> addProduct(int compositionId);
  Future<Either<Failure, Success>> removeProduct(int compositionId);
  Future<Either<Failure, List<BasketProduct>>> getMyBasket();
  Future<Either<Failure, Success>> updateProduct(int compositionId, int quantity);
  Future<Either<Failure, Success>> clearBasket();
}

class BasketRemoteDataImpl extends BasketRemoteDataSource {
  final Api api;

  BasketRemoteDataImpl(this.api);

  @override
  Future<Either<Failure, List<int>>> getMyBasketProductIds() async {
    try {
      var response = await api.dio.get('v1/baskets/ids');
      final payload = response.data['payload'];

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
  Future<Either<Failure, Success>> addProduct(int compositionId) async {
    try {
      await api.dio.post('v1/baskets', data: {'composition_id': compositionId});

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> removeProduct(int compositionId) async {
    try {
      await api.dio.delete('v1/baskets/$compositionId');

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<BasketProduct>>> getMyBasket() async {
    try {
      var response = await api.dio.get('v1/baskets');
      final payload = response.data['payload'];

      if (payload is Map<String, dynamic>) {
        if (payload.isEmpty) {
          return Right([]);
        }
        return Right([BasketProduct.fromJson(payload)]);
      }

      if (payload is List) {
        return Right(payload.map((e) => BasketProduct.fromJson(e)).toList());
      }
      throw Exception('Unexpected payload type');
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> updateProduct(int compositionId, int quantity) async {
    try {
      await api.dio.patch(
        'v1/baskets',
        data: {'composition_id': compositionId, 'quantity': quantity},
      );

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> clearBasket() async {
    try {
      await api.dio.delete('v1/baskets/all');

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }
}
