import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../features/auth/data/employee_local_data_source.dart';
import 'failure.dart';

String baseUrl = 'https://meninki.kamilussat.com';

initBaseUrl() {
  if (kDebugMode) {
    baseUrl = 'https://meninki.kamilussat.com';
  }
  if (kReleaseMode) {
    baseUrl = 'https://meninki.kamilussat.com';
  }
  //   baseUrl = 'http://119.235.112.154:4444/api';
  //  baseUrl = 'http://172.20.14.17:8066/api';
  //  baseUrl = 'http://172.20.17.52:8066/api';
}

class Api {
  final EmployeeLocalDataSource emplDs;

  Api(this.emplDs);

  Dio dio = Dio(
    BaseOptions(
      receiveTimeout: const Duration(minutes: 5),
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(minutes: 5),
      baseUrl: "$baseUrl/api/v1/",
    ),
  );

  Future initApiClient() async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print(options.path);
          // Add access token for non-authentication requests
          final token = emplDs.user?.token;
          if (token != null) {
            options.headers['Authorization'] = "Bearer ${token.access.token}";
          }

          return handler.next(options);
        },
        onError: (e, handler) async {
          print((e.response?.statusCode).toString());
          print(e.response?.data.toString());
          if (e.response?.statusCode == 401 || e.response?.statusCode == 498) {
            return handler.reject(DioException(requestOptions: e.requestOptions, error: e));
          }
          // Check if the error is network-related (offline)
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.connectionError) {
            log('Network error: User is likely offline.');
            // Optionally show a message to the user or handle it gracefully
            // Avoid logging out the user for network issues
            return handler.reject(e);
          } else {
            return handler.reject(e);
          }
        },
      ),
    );
  }
}

class RefreshError {
  DioException err;
  ErrorInterceptorHandler handl;
  RefreshError({required this.err, required this.handl});
}

class Request {
  RequestOptions options;
  RequestInterceptorHandler handl;
  Request({required this.options, required this.handl});
}

Failure handleError(Object e) {
  if (e is DioException) {
    int? statusCode = e.response?.statusCode;
    String message = 'An unexpected error occurred';

    final data = e.response?.data;
    if (data is Map && data['error'] != null) {
      var error = data['error'];

      // 👇 Decode if backend sent error as a JSON string
      if (error is String) {
        try {
          error = jsonDecode(error);
        } catch (_) {
          // not a valid json, ignore
        }
      }

      // Now safely extract message
      if (error is Map && error['message'] != null) {
        final msg = error['message'];
        if (msg is List && msg.isNotEmpty) {
          message = msg.first.toString();
        } else if (msg is String) {
          message = msg;
        }
      }
    } else if (data?['message'] != null) {
      message = data['message'].toString();
    }

    return Failure(statusCode: statusCode, message: message);
  }

  return const Failure(message: 'Unexpected error');
}
