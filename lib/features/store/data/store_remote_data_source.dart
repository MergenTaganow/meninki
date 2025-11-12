import 'package:dartz/dartz.dart';
import 'package:meninki/core/success.dart';
import '../../../core/api.dart';
import '../../../core/failure.dart';

abstract class StoreRemoteDataSource {
  Future<Either<Failure, Success>> storeCreate(Map map);
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
}
