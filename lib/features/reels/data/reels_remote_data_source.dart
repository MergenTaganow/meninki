import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meninki/core/success.dart';
import 'package:meninki/features/categories/models/brand.dart';
import 'package:meninki/features/categories/models/category.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';
import 'package:meninki/features/reels/model/reels.dart';
import '../../../core/api.dart';
import '../../../core/failure.dart';
import '../model/query.dart';

abstract class ReelsRemoteDataSource {
  Future<Either<Failure, List<Reel>>> getReels(Query? query);
  Stream<(double, MeninkiFile?)> uploadFile(File file);
  Future<Either<Failure, List<int>>> getLikedReels();
  Future<Either<Failure, Success>> likeReel(int reelId);
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Brand>>> getBrands(Query? query);
  Future<Either<Failure, Success>> createReel(Map<String, dynamic> map);
}

class ReelsRemoteDataImpl extends ReelsRemoteDataSource {
  final Api api;
  ReelsRemoteDataImpl(this.api);

  @override
  Future<Either<Failure, List<Reel>>> getReels(Query? query) async {
    try {
      var response = await api.dio.get('v1/reels', queryParameters: query?.toMap());

      List<Reel> reels = (response.data['payload'] as List).map((e) => Reel.fromJson(e)).toList();
      return Right(reels);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Stream<(double, MeninkiFile?)> uploadFile(File file) async* {
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

    // We'll use StreamController for progress updates.
    final controller = StreamController<(double, MeninkiFile?)>();

    try {
      await api.dio
          .post(
            'media/v1/files',
            data: formData,
            onSendProgress: (sent, total) {
              if (total > 0) {
                final progress = sent / total;
                controller.add((progress, null)); // 🚀 emit progress
              }
            },
          )
          .then((response) {
            print(response.data);
            final files = (response.data as List).map((e) => MeninkiFile.fromJson(e)).toList();
            if (files.isEmpty) {
              controller.addError({"message": "smthWentWrong"});
            }
            controller.add((1.0, files.first)); // ✅ final success value
          })
          .catchError((e, s) {
            controller.addError(e);
          })
          .whenComplete(() {
            controller.close();
          });

      // Return controller’s stream
      yield* controller.stream;
    } catch (e) {
      rethrow;
    }
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
    try {
      var response = await api.dio.get('v1/categories', queryParameters: {"lang": "tk"});

      var list = (response.data['payload'] as List).map((e) => Category.fromJson(e)).toList();
      return Right(list);
    } catch (e) {
      return Left(handleError(e));
    }
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
}
