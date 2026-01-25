import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meninki/core/success.dart';
import 'package:meninki/features/categories/models/brand.dart';
import 'package:meninki/features/categories/models/category.dart';
import 'package:meninki/features/comments/models/comment.dart';
import 'package:meninki/features/reels/blocs/get_reel_markets/get_reel_markets_bloc.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';
import 'package:meninki/features/reels/model/reels.dart';
import '../../../core/api.dart';
import '../../../core/failure.dart';
import '../model/query.dart';

abstract class ReelsRemoteDataSource {
  Future<Either<Failure, List<Reel>>> getReels(Query? query);
  Future<Either<Failure, List<Reel>>> getFilteredReels(Query? query);
  Future<Either<Failure, List<Reel>>> getMyReels(Query? query);
  Stream<(double, MeninkiFile?)> uploadFile(File file);
  Future<Either<Failure, List<int>>> getLikedReels();
  Future<Either<Failure, Success>> likeReel(int reelId);
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Brand>>> getBrands(Query? query);
  Future<Either<Failure, Success>> createReel(Map<String, dynamic> map);
  Future<Either<Failure, List<Comment>>> getComments({required int reelId, Query? query});
  Future<Either<Failure, Comment>> sendComment(Map<String, dynamic> map);
  Future<Either<Failure, Comment>> commentById(int id);
  Future<Either<Failure, MeninkiFile>> getFileById(int id);
  Future<Either<Failure, List<ReelMarket>>> getReelMarkets(Query? query);
}

class ReelsRemoteDataImpl extends ReelsRemoteDataSource {
  final Api api;
  ReelsRemoteDataImpl(this.api);

  @override
  Future<Either<Failure, List<Reel>>> getReels(Query? query) async {
    try {
      ///Todo later need to control verified and other urls
      var response = await api.dio.get('v1/reels/verified', queryParameters: query?.toMap());

      List<Reel> reels = (response.data['payload'] as List).map((e) => Reel.fromJson(e)).toList();
      return Right(reels);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<Reel>>> getFilteredReels(Query? query) async {
    try {
      ///Todo later need to control verified and other urls
      var response = await api.dio.get('v1/reels/verified', queryParameters: query?.toMap());

      List<Reel> reels = (response.data['payload'] as List).map((e) => Reel.fromJson(e)).toList();
      return Right(reels);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Stream<(double, MeninkiFile?)> uploadFile(File file) {
    final controller = StreamController<(double, MeninkiFile?)>();

    () async {
      try {
        final fileName = file.path.split('/').last;

        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            headers: {
              'filepath': [file.path],
            },
          ),
        });

        final response = await api.dio.post(
          'media/v1/files',
          data: formData,
          onSendProgress: (sent, total) {
            if (total > 0 && !controller.isClosed) {
              controller.add((sent / total, null)); // ✅ progress update
            }
          },
        );

        final files = (response.data as List).map((e) => MeninkiFile.fromJson(e)).toList();

        if (files.isEmpty) {
          if (!controller.isClosed) {
            controller.addError({"message": "smthWentWrong"});
          }
          return;
        }

        // ✅ ALWAYS emit success BEFORE closing
        if (!controller.isClosed) {
          controller.add((1.0, files.first));
        }

        // ✅ Give event loop one tick to deliver last value
        await Future.delayed(Duration.zero);
      } catch (e, s) {
        if (!controller.isClosed) {
          controller.addError(e);
        }
      } finally {
        if (!controller.isClosed) {
          await controller.close();
        }
      }
    }();

    return controller.stream;
  }

  @override
  Future<Either<Failure, List<int>>> getLikedReels() async {
    try {
      var response = await api.dio.get('v1/reel-favorites/client');

      List<int> list = (response.data['payload'] as List).map((e) => e as int).toList();
      return Right(list);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> likeReel(int reelId) async {
    try {
      await api.dio.post('v1/reel-favorites', data: {"reel_id": reelId});

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    // try {
    var response = await api.dio.get('v1/categories', queryParameters: {"lang": "tk"});

    final payload = response.data['payload'];

    final List<Category> list =
        (payload is List ? payload : [payload])
            .map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList();

    return Right(list);
    // } catch (e) {
    //   return Left(handleError(e));
    // }
  }

  @override
  Future<Either<Failure, List<Brand>>> getBrands(Query? query) async {
    try {
      var response = await api.dio.get('v1/brands', queryParameters: query?.toMap());

      List<Brand> reels = (response.data['payload'] as List).map((e) => Brand.fromJson(e)).toList();
      return Right(reels);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> createReel(Map<String, dynamic> map) async {
    try {
      await api.dio.post('v1/reels', data: map);

      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getComments({required int reelId, Query? query}) async {
    // try {
    var response = await api.dio.get(
      'v1/reel-comments',
      queryParameters: {"reel_id": reelId, ...?query?.toMap()},
    );

    List<Comment> comments =
        (response.data['payload'] as List).map((e) => Comment.fromJson(e)).toList();
    return Right(comments);
    // } catch (e) {
    //   return Left(handleError(e));
    // }
  }

  @override
  Future<Either<Failure, Comment>> sendComment(Map<String, dynamic> map) async {
    // try {
    var response = await api.dio.post('v1/reel-comments', data: map);

    var comment = Comment.fromJson(response.data['payload']);
    return Right(comment);
    // } catch (e) {
    //   return Left(handleError(e));
    // }
  }

  @override
  Future<Either<Failure, Comment>> commentById(int id) async {
    // try {
    var response = await api.dio.get('v1/reel-comments/$id');

    Comment comment = Comment.fromJson(response.data['payload']);
    return Right(comment);
    // } catch (e) {
    //   return Left(handleError(e));
    // }
  }

  @override
  Future<Either<Failure, List<Reel>>> getMyReels(Query? query) async {
    try {
      ///Todo later need to control verified and other urls
      var response = await api.dio.get('v1/reels', queryParameters: query?.toMap());

      List<Reel> reels = (response.data['payload'] as List).map((e) => Reel.fromJson(e)).toList();
      return Right(reels);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, MeninkiFile>> getFileById(int id) async {
    // try {
    var response = await api.dio.get('media/v1/files/$id');

    print(response.data);
    final files = (response.data as List).map((e) => MeninkiFile.fromJson(e)).toList();

    return Right(files.first);
    // } catch (e) {
    //   return Left(handleError(e));
    // }
  }

  @override
  Future<Either<Failure, List<ReelMarket>>> getReelMarkets(Query? query) async {
    // try {
      ///Todo later need to control verified and other urls
      var response = await api.dio.get('v1/reels/market/count', queryParameters: query?.toMap());

      List<ReelMarket> reels =
          (response.data['payload'] as List).map((e) => ReelMarket.fromJson(e)).toList();
      return Right(reels);
    // } catch (e) {
    //   return Left(handleError(e));
    // }
  }
}
