import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:meninki/features/home/model/profile.dart';
import '../../../core/api.dart';
import '../../../core/failure.dart';
import '../../../core/success.dart';
import '../models/user.dart';
import 'employee_local_data_source.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
    bool rememberMe = false,
    // Position? location
  });
  Future<Either<Failure, Success>> sendOtp({required String phoneNumber});
  Future<Either<Failure, User>> checkOtp({required String phoneNumber, required int otp});
  Future<Either<Failure, User>> register(Map<String, dynamic> data);
  Future<Either<Failure, Profile>> getMyProfile();
}

class AuthRemoteDataImpl extends AuthRemoteDataSource {
  final Api api;
  final EmployeeLocalDataSource local;
  AuthRemoteDataImpl(this.api, this.local);

  @override
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
    bool rememberMe = false,
    // Position? location
  }) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      Map<String, dynamic>? header;
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        log('${androidInfo.manufacturer} ${androidInfo.model}');
        header = {
          'deviceName': '${androidInfo.manufacturer} ${androidInfo.model}',
          'Sec-CH-UA-Platform': Platform.isAndroid ? 'Android' : 'Ios',
          'Sec-CH-UA-Platform-Version': androidInfo.version,
          'Sec-CH-UA-Model': '${androidInfo.manufacturer} ${androidInfo.model}',
          'Sec-CH-UA-Mobile': true,
          'Content-Type': 'application/json',
          'Accept': "application/json",
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        log(iosInfo.utsname.machine); // Log the machine name, e.g., 'iPhone13,2'

        header = {
          'deviceName': iosInfo.utsname.machine,
          'Sec-CH-UA-Platform': Platform.isAndroid ? 'Android' : 'iOS',
          'Sec-CH-UA-Platform-Version': iosInfo.systemVersion,
          'Sec-CH-UA-Model': iosInfo.utsname.machine,
          'Sec-CH-UA-Mobile': true,
          'Content-Type': 'application/json',
          'Accept': "application/json",
        };
      }
      var data = {'userName': username, 'password': password};
      var response = await api.dio.post(
        '/admin/v1/employees/login',
        data: data,
        options: Options(headers: header),
      );
      if (response.statusCode == 200) {
        final userMap =
            response.data['accesses']..addAll({
              "token": response.data['token'],
              "fullName": response.data['fullName'],
              'name': response.data['fullName'],
              'username': username,
              'uuid': response.data['uuid'],
            });
        if (!userMap.containsKey("item")) userMap['item'] = [];

        User? user = User.fromJson(userMap);
        // set token to dio header
        final token = user.token;
        if (token != null) {
          api.dio.options.headers['Authorization'] = "Bearer $token";
        }
        // save user to local data source
        local.saveUser(u: user);
        return Right(user);
      } else {
        return Left(Failure(statusCode: response.statusCode, message: response.data.toString()));
      }
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> sendOtp({required String phoneNumber}) async {
    try {
      var response = await api.dio.post(
        'v1/authentications/send-otp',
        data: {'phonenumber': phoneNumber},
      );
      if (response.statusCode == 201) {
        return Right(Success());
      } else {
        return Left(Failure(statusCode: response.statusCode, message: response.data.toString()));
      }
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, User>> checkOtp({required String phoneNumber, required int otp}) async {
    try {
      var response = await api.dio.post(
        'v1/authentications/validate-otp',
        data: {'phonenumber': phoneNumber, "otp": otp},
      );
      print(response.data);
      User user;
      if (response.data['payload'] is String) {
        user = User(temporaryToken: response.data['payload']);
      } else {
        user = User.fromJson(response.data['payload']);
      }
      return Right(user);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, User>> register(Map<String, dynamic> data) async {
    try {
      var response = await api.dio.post('v1/authentications/registration', data: data);

      User user = User.fromJson(response.data['payload']);
      return Right(user);
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Profile>> getMyProfile() async {
    try {
      var response = await api.dio.get('v1/profiles');

      Profile profile = Profile.fromJson(response.data['payload']);
      return Right(profile);
    } catch (e) {
      return Left(handleError(e));
    }
  }
}
