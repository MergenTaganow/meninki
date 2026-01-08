import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:meninki/core/success.dart';
import 'package:meninki/features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import 'package:meninki/features/global/blocs/key_filter_cubit/key_filter_cubit.dart';
import 'package:meninki/features/global/blocs/sort_cubit/sort_cubit.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meninki/features/product/models/product_atribute.dart';
import 'package:meninki/features/product/models/product_parameters.dart';
import 'package:meninki/features/province/blocks/province_selecting_cubit/province_selecting_cubit.dart';
import 'package:meninki/features/province/models/province.dart';
import 'package:meninki/features/reels/model/query.dart';
import '../../../core/api.dart';
import '../../../core/failure.dart';
import '../../../core/injector.dart';

abstract class ProductRemoteDataSource {
  Future<Either<Failure, Product>> createProduct(Map<String, dynamic> data);
  Future<Either<Failure, Product>> getProductById(int id);
  Future<Either<Failure, List<Product>>> getProducts(Query query);
  Future<Either<Failure, List<ProductParameter>>> getParameters(Query query);
  Future<Either<Failure, List<ProductAttribute>>> getAttributes(Query query);
  Future<Either<Failure, Success>> sendComposition(Map<String, dynamic> data);
  Future<Either<Failure, List<Province>>> getProvinces();
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
      var response = await api.dio.get('v1/products/$id', queryParameters: {"lang": "tk"});
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
      var response = await api.dio.post('v1/compositions', data: data);
      print(response.data);

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts(Query query) async {
    // try {
    var sort = sl<SortCubit>().sortMap[SortCubit.productSearchSort];
    var provinces =
        sl<ProvinceSelectingCubit>().selectedMap[ProvinceSelectingCubit
            .product_searching_province] ??
        [];
    var categories =
        sl<CategorySelectingCubit>().selectedMap[CategorySelectingCubit
            .product_searching_category] ??
        [];
    var keyFilters = sl<KeyFilterCubit>().selectedMap;
    print(sl<CategorySelectingCubit>().selectedMap);
    print(categories);

    var map = {
      ...query.toMap(),
      "lang": "tk",
      if (sort != null) ...sort.toMap() else ...{"order_direction": "asc", "order_by": "id"},
      if (provinces.isNotEmpty) "province_ids": provinces.map((e) => e.id).toList(),
      if (categories.isNotEmpty) "category_ids": categories.map((e) => e.id).toList(),
      if (keyFilters[KeyFilterCubit.product_search_max_price] != null)
        "max_price": keyFilters[KeyFilterCubit.product_search_max_price],
      if (keyFilters[KeyFilterCubit.product_search_min_price] != null)
        "min_price": keyFilters[KeyFilterCubit.product_search_min_price],
    };
    print("map$map");
    var response = await api.dio.get('v1/products', queryParameters: map);

    List<Product> product =
        (response.data['payload'] as List).map((e) => Product.fromJson(e)).toList();
    return Right(product);
    // } catch (e) {
    //   return Left(handleError(e));
    // }
  }

  @override
  Future<Either<Failure, List<Province>>> getProvinces() async {
    // try {
    var response = await api.dio.get(
      'v1/provinces',
      queryParameters: {"page": 1, "limit": 100, "order_direction": "asc", "order_by": "id"},
    );

    List<Province> province =
        (response.data['payload'] as List).map((e) => Province.fromJson(e)).toList();
    return Right(province);
    // } catch (e) {
    //   return Left(handleError(e));
    // }
  }
}
