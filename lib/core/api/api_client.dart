import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:task_manager/core/api/HTTPMethod.dart';
import 'package:task_manager/core/api/either.dart';
import 'package:task_manager/core/consts/api_consts.dart';

class APIError implements Exception {
  final String message;
  APIError(this.message);

  @override
  String toString() => message;
}

class APIRequest {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: apiUrl!,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "x-mock-match-request-body": "true",
      },
    ),
  );

  static Future<bool> _isInternetAvailable() async {
    try {
      final foo = await InternetAddress.lookup('google.com');
      return foo.isNotEmpty && foo[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<Either<APIError, Model>> call<Parameters, Model>({
    required String path,
    required HTTPMethod method,
    Parameters? parameters,
    Map<String, String>? headers,
    required Model Function(dynamic data) fromJson,
  }) async {
    try {

      bool isConnected = await _isInternetAvailable();
      if (!isConnected) {
        return Left<APIError, Model>(APIError("No internet connection"));
      }

      final response = await _dio.request(
        path,
        data: parameters != null ? jsonEncode(parameters) : null,
        options: Options(
          method: method.name.toUpperCase(),
          headers: headers,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right<APIError, Model>(fromJson(response.data));
      } else {
        return Left<APIError, Model>(
            APIError("Request failed with status: ${response.statusCode}"));
      }
    } catch (e) {
      return Left<APIError, Model>(APIError("Failed to make the request: $e"));
    }
  }
}
