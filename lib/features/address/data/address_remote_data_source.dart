import 'package:dartz/dartz.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/core/success.dart';
import 'package:meninki/features/address/models/address.dart';
import 'package:meninki/features/address/models/region.dart';
import '../../../core/failure.dart';
import '../../reels/model/query.dart';

abstract class AddressRemoteDataSource {
  Future<Either<Failure, List<Region>>> getRegions(Query? query);
  Future<Either<Failure, Address>> createAddress(Map<String, dynamic> data);
  Future<Either<Failure, List<Address>>> getAddresses();
  Future<Either<Failure, Success>> deleteAddress(int id);
}

class AddressRemoteDataSourceImpl extends AddressRemoteDataSource {
  final Api api;
  AddressRemoteDataSourceImpl(this.api);

  @override
  Future<Either<Failure, List<Region>>> getRegions(Query? query) async {
    try {
      var param = {if (query != null) ...query.toMap()};
      var response = await api.dio.get('v1/regions', queryParameters: param);

      List<Region> product =
          (response.data['payload'] as List).map((e) => Region.fromJson(e)).toList();
      return Right(product);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Address>> createAddress(Map<String, dynamic> data) async {
    try {
      var response = await api.dio.post('v1/addresses', data: data);
      print(response.data);

      Address product = Address.fromJson(response.data['payload']);
      return Right(product);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      var response = await api.dio.get('v1/addresses');
      final payload = response.data['payload'];

      final List<Address> list =
          (payload is List ? payload : [payload])
              .map((e) => Address.fromJson(e as Map<String, dynamic>))
              .toList();

      return Right(list);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteAddress(int id) async {
    try {
      await api.dio.delete('v1/addresses/$id');

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }
}
