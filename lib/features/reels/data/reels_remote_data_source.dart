import 'package:dartz/dartz.dart';
import 'package:meninki/features/reels/model/reels.dart';
import '../../../core/api.dart';
import '../../../core/failure.dart';
import '../model/query.dart';

abstract class ReelsRemoteDataSource {
  Future<Either<Failure, List<Reel>>> getReels(Query? query);
}

class ReelsRemoteDataImpl extends ReelsRemoteDataSource {
  final Api api;
  ReelsRemoteDataImpl(this.api);

  @override
  Future<Either<Failure, List<Reel>>> getReels(Query? query) async {
    // try {
      print(query?.toMap());
      var response = await api.dio.get('reels', queryParameters: query?.toMap());

      List<Reel> reels = (response.data['payload'] as List).map((e) => Reel.fromJson(e)).toList();
      return Right(reels);
    // } catch (e) {
    //   return Left(handleError(e));
    // }
  }
}
