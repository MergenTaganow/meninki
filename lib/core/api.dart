import 'dart:convert';
import 'package:dio/dio.dart';
import '../features/auth/data/employee_local_data_source.dart';
import '../features/auth/models/user.dart';
import 'failure.dart';

String baseUrl = 'https://meninki.asuda.agency';

class Api {
  final EmployeeLocalDataSource emplDs;

  Api(this.emplDs);

  Dio dio = Dio(
    BaseOptions(
      receiveTimeout: const Duration(minutes: 5),
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(minutes: 5),
      baseUrl: "$baseUrl/api/",
    ),
  );

  Future initApiClient() async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print(options.path);
          // Add access token for non-authentication requests
          if (!options.path.contains("change-token")) {
            final token = emplDs.user?.token;
            if (token != null) {
              options.headers['Authorization'] = "Bearer ${token.access.token}";
            }
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          print((e.response?.statusCode).toString());
          print(e.response?.data.toString());
          if (e.response?.statusCode == 401) {
            String? token = await _refreshToken(emplDs.user?.token?.refresh);

            if (token != null) {
              e.requestOptions.headers['Authorization'] = "Bearer $token";
              dynamic newData = e.requestOptions.data;

              // Handle FormData (file upload)
              if (newData is FormData) {
                final oldFormData = newData;
                final rebuilt = FormData();

                // Copy normal fields
                rebuilt.fields.addAll(oldFormData.fields);

                // Rebuild files using stored filepath in headers
                for (final entry in oldFormData.files) {
                  final oldFile = entry.value;
                  final headers = oldFile.headers;
                  final filePaths = headers?['filepath'] as List<dynamic>?;

                  if (filePaths != null && filePaths.isNotEmpty) {
                    final path = filePaths.first.toString();
                    rebuilt.files.add(
                      MapEntry(
                        entry.key,
                        await MultipartFile.fromFile(
                          path,
                          filename: oldFile.filename,
                          contentType: oldFile.contentType,
                        ),
                      ),
                    );
                  } else {
                    print('⚠️ Cannot rebuild file, filepath header missing.');
                  }
                }

                newData = rebuilt;
              }

              final resp = await dio.request(
                e.requestOptions.path,
                data: newData,
                queryParameters: e.requestOptions.queryParameters,
                options: Options(method: e.requestOptions.method),
              );
              handler.resolve(resp);
              return;
            }

            return handler.reject(e);
          }
          return handler.reject(e);
        },
      ),
    );
  }

  Future<String?> _refreshToken(String? refreshToken) async {
    try {
      final response = await dio.post(
        'v1/authentications/change-token',
        data: {'token': refreshToken},
      );

      final User user = User.fromJson(response.data['payload']);
      user.token?.refresh = refreshToken;
      // save user to local data source
      emplDs.saveUser(u: user);

      return emplDs.user?.token?.access.token;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {}
      return null;
    }
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
