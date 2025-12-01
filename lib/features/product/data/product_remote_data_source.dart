import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:meninki/core/success.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meninki/features/product/models/product_atribute.dart';
import 'package:meninki/features/product/models/product_parameters.dart';
import 'package:meninki/features/reels/model/query.dart';
import '../../../core/api.dart';
import '../../../core/failure.dart';

abstract class ProductRemoteDataSource {
  Future<Either<Failure, Product>> createProduct(Map<String, dynamic> data);
  Future<Either<Failure, Product>> getProductById(int id);
  Future<Either<Failure, List<ProductParameter>>> getParameters(Query query);
  Future<Either<Failure, List<ProductAttribute>>> getAttributes(Query query);
  Future<Either<Failure, Success>> sendComposition(Map<String, dynamic> data);
}

class ProductRemoteDataImpl extends ProductRemoteDataSource {
  final Api api;
  ProductRemoteDataImpl(this.api);

  @override
  Future<Either<Failure, Product>> createProduct(Map<String, dynamic> data) async {
    try {
      var response = await api.dio.post('v1/manager/products', data: data);
      print(response.data);

      return Right(Product.fromJson(response.data['payload']));
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      var response = await api.dio.get('v1/manager/products/$id', queryParameters: {"lang": "tk"});
      print(response.data);

      return Right(Product.fromJson(response.data['payload']));
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<ProductParameter>>> getParameters(Query query) async {
    try {
      var response = await api.dio.get(
        'v1/parameters',
        queryParameters: {...query.toMap(), "lang": "tk"},
      );

      List<ProductParameter> reels =
          (response.data['payload'] as List).map((e) => ProductParameter.fromJson(e)).toList();
      return Right(reels);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<ProductAttribute>>> getAttributes(Query query) async {
    try {
      var response = await api.dio.get(
        'v1/attributes',
        queryParameters: {...query.toMap(), "lang": "tk"},
      );

      List<ProductAttribute> reels =
          (response.data['payload'] as List).map((e) => ProductAttribute.fromJson(e)).toList();
      return Right(reels);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> sendComposition(Map<String, dynamic> data) async {
    try {
      var response = await api.dio.post('v1/manager/compositions', data: data);
      print(response.data);

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }
}
