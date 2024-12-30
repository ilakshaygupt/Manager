import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_manager/core/api/HTTPMethod.dart';
import 'package:task_manager/core/api/either.dart';
import 'package:task_manager/core/consts/api_consts.dart';

class APIError implements Exception {
  final String message;
  APIError(this.message);

  @override
  String toString() => message;
}

class APIRequest<Parameters, Model> {
  static Future<Either<APIError, Model>> call<Parameters, Model>({
    required String path,
    required HTTPMethod method,
    Parameters? parameters,
    Map<String, String>? headers,
    required Model Function(dynamic data) fromJson,
  }) async {
    final url = Uri.parse("$apiUrl$path");

    final requestHeaders = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "x-mock-match-request-body": "true",
      if (headers != null) ...headers,
    };

    try {
      final response = http.Request(method.name.toUpperCase(), url)
        ..headers.addAll(requestHeaders)
        ..body = parameters != null ? jsonEncode(parameters) : '';

      final streamedResponse = await http.Client().send(response);
      final responseData = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        return Right<APIError, Model>(fromJson(jsonDecode(responseData)));
      } else {
        return Left<APIError, Model>(APIError(
            "Request failed with status: ${streamedResponse.statusCode}"));
      }
    } catch (e) {
      return Left<APIError, Model>(APIError("Failed to make the request: $e"));
    }
  }
}
