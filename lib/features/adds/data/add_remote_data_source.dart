import 'package:dartz/dartz.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/features/adds/models/add.dart';

import '../../../core/failure.dart';

abstract class AddRemoteDataSource {
  Future<Either<Failure, Add>> createAdd(Map<String, dynamic> data);
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
}
