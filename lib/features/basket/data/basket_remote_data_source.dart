import 'package:dartz/dartz.dart';
import 'package:meninki/features/orders/model/order.dart';
import 'package:meninki/features/reels/model/query.dart';

import '../../../core/api.dart';
import '../../../core/failure.dart';
import '../../../core/success.dart';
import '../models/basket_product.dart';
import '../models/prepared_basket.dart';

abstract class BasketRemoteDataSource {
  Future<Either<Failure, List<int>>> getMyBasketProductIds();
  Future<Either<Failure, Success>> addProduct(int compositionId);
  Future<Either<Failure, Success>> removeProduct(int compositionId);
  Future<Either<Failure, List<BasketProduct>>> getMyBasket();
  Future<Either<Failure, Success>> updateProduct(int compositionId, int quantity);
  Future<Either<Failure, Success>> clearBasket();
  Future<Either<Failure, PreparedBasket>> prepareBasket(int addressId);
  Future<Either<Failure, Success>> orderCreate(Map<String, dynamic> data);
  Future<Either<Failure, List<MeninkiOrder>>> getOrders(Query query);
  Future<Either<Failure, MeninkiOrder>> getOrderId(int id, bool clientOrder);
  Future<Either<Failure, List<OrderProduct>>> getMarketOrders(Query query);
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

  @override
  Future<Either<Failure, PreparedBasket>> prepareBasket(int addressId) async {
    try {
      final response = await api.dio.post(
        'v1/baskets/prepare',
        data: {"address_id": addressId, "lang": 'tk'},
      );
      print(response.data);

      final payload = response.data['payload'];

      return Right(PreparedBasket.fromJson(payload));
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> orderCreate(Map<String, dynamic> data) async {
    try {
      await api.dio.post('v1/orders', data: data);

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<MeninkiOrder>>> getOrders(Query query) async {
    try {
      var response = await api.dio.get(
        'v1/${query.extraUrl != null ? '${query.extraUrl}/' : ''}orders',
        queryParameters: query.toMap(),
      );

      List<MeninkiOrder> reels =
          (response.data['payload'] as List).map((e) => MeninkiOrder.fromJson(e)).toList();
      return Right(reels);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, MeninkiOrder>> getOrderId(int id, bool clientOrder) async {
    try {
      var response = await api.dio.get('v1/${clientOrder ? 'client/' : ''}orders/$id');

      var order = MeninkiOrder.fromJson(response.data['payload']);
      return Right(order);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<OrderProduct>>> getMarketOrders(Query query) async {
    try {
      var response = await api.dio.get('v1/orders/client/market', queryParameters: query.toMap());

      List<OrderProduct> reels =
          (response.data['payload'] as List).map((e) => OrderProduct.fromJson(e)).toList();
      return Right(reels);
    } catch (e) {
      return Left(handleError(e));
    }
  }
}
