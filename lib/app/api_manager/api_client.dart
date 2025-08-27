import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'api_checker.dart';
import 'error_response.dart';
import '../app_service/app_service.dart';

class ApiClient extends GetxService {
  final String appBaseUrl = "http://swiperanks.com/api/";
  final String url = "http://swiperanks.com/uploads/icons/";
  static const String noInternetMessage =
      'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;
  final int maxRetries = 3;
  final int retryDelaySeconds = 2;
  String? token;
  String? type;

  // Method to set authentication token
  void setAuthToken(String? authToken) {
    token = authToken;
    _logWithTimestamp(
        '====> AUTH TOKEN SET: ${token != null ? "Present" : "Not Present"}');
  }

  // Method to get current authentication token
  String? getAuthToken() {
    return token;
  }

  // Method to clear authentication token
  void clearAuthToken() {
    token = null;
    _logWithTimestamp('====> AUTH TOKEN CLEARED');
  }

  // Method to initialize API client with stored token
  Future<void> initializeWithStoredToken() async {
    try {
      // This will be called from the main app after SecureStorage is available
      _logWithTimestamp('====> INITIALIZE WITH STORED TOKEN CALLED');
    } catch (e) {
      _logWithTimestamp('====> ERROR INITIALIZING WITH STORED TOKEN: $e');
    }
  }

  // Helper method to format curl commands
  String _formatCurlCommand(
      String method, String url, Map<String, String>? headers,
      [dynamic body]) {
    StringBuffer curl = StringBuffer('curl -X $method "$url"');

    // Add headers
    if (headers != null && headers.isNotEmpty) {
      headers.forEach((key, value) {
        curl.write(' -H "$key: $value"');
      });
    }

    // Add main headers
    if (mainHeaders != null && mainHeaders!.isNotEmpty) {
      mainHeaders!.forEach((key, value) {
        curl.write(' -H "$key: $value"');
      });
    }

    // Add body for POST/PUT requests
    if (body != null && (method == 'POST' || method == 'PUT')) {
      if (body is Map) {
        curl.write(' -d \'${jsonEncode(body)}\'');
      } else {
        curl.write(' -d \'$body\'');
      }
    }

    return curl.toString();
  }

  // Helper method to print timestamped logs
  void _logWithTimestamp(String message) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] $message');
  }

  Map<String, String> get mainHeaders {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Add authorization header if token is present
    if (token != null && token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      _logWithTimestamp(
          '====> AUTH HEADER ADDED: Bearer ${token!.substring(0, 10)}...');
    }

    return headers;
  }

  Future<Response> getData(String uri,
      {Map<String, dynamic>? query,
      Map<String, String>? headers,
      bool handleError = true}) async {
    _logWithTimestamp("====> API REQUEST STARTED =====");
    _logWithTimestamp("HELLO URL :: ${uri}");
    _logWithTimestamp("HELLO URL FULL :: ${appBaseUrl + uri}");

    try {
      // Build query parameters for curl
      String queryString = '';
      if (query != null && query.isNotEmpty) {
        queryString = '?' +
            query.entries
                .map((e) =>
                    '${e.key}=${Uri.encodeComponent(e.value.toString())}')
                .join('&');
      }

      // Print curl command
      _logWithTimestamp('====> CURL COMMAND:');
      _logWithTimestamp(
          _formatCurlCommand('GET', appBaseUrl + uri + queryString, headers));
      _logWithTimestamp('====> API Call: $uri');
      _logWithTimestamp('====> Headers: ${headers ?? mainHeaders}');
      _logWithTimestamp('====> Query Params: $query');

      http.Response response = await http
          .get(
            Uri.parse(appBaseUrl + uri),
            headers: headers ?? mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      // Print response details
      _logWithTimestamp('====> RESPONSE STATUS: ${response.statusCode}');
      _logWithTimestamp('====> RESPONSE HEADERS: ${response.headers}');
      _logWithTimestamp('====> RESPONSE BODY: ${response.body}');

      _logWithTimestamp("====> API REQUEST COMPLETED =====");
      return handleResponse(response, uri, handleError);
    } catch (e) {
      _logWithTimestamp('====> API ERROR: $e');
      _logWithTimestamp("====> API REQUEST FAILED =====");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers, bool handleError = true}) async {
    _logWithTimestamp("====> API REQUEST STARTED =====");

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        _logWithTimestamp('====> ATTEMPT $attempt of $maxRetries');

        // Print curl command
        _logWithTimestamp('====> CURL COMMAND:');
        _logWithTimestamp(
            _formatCurlCommand('POST', appBaseUrl + uri, headers, body));
        _logWithTimestamp('====> API Call: $uri');
        _logWithTimestamp('====> Headers: ${headers ?? mainHeaders}');
        _logWithTimestamp('====> Request Body: $body');

        http.Response response = await http
            .post(
              Uri.parse(appBaseUrl + uri),
              body: jsonEncode(body),
              headers: headers ?? mainHeaders,
            )
            .timeout(Duration(seconds: timeoutInSeconds));

        // Print response details
        _logWithTimestamp('====> RESPONSE STATUS: ${response.statusCode}');
        _logWithTimestamp('====> RESPONSE HEADERS: ${response.headers}');
        _logWithTimestamp('====> RESPONSE BODY: ${response.body}');

        _logWithTimestamp("====> API REQUEST COMPLETED =====");
        return handleResponse(response, uri, handleError);
      } catch (e) {
        _logWithTimestamp('====> ATTEMPT $attempt FAILED: $e');

        if (attempt < maxRetries) {
          _logWithTimestamp(
              '====> RETRYING IN ${retryDelaySeconds} SECONDS...');
          await Future.delayed(Duration(seconds: retryDelaySeconds));
        } else {
          _logWithTimestamp('====> ALL RETRY ATTEMPTS FAILED');
          return const Response(statusCode: 1, statusText: noInternetMessage);
        }
      }
    }

    return const Response(statusCode: 1, statusText: noInternetMessage);
  }

  Future<Response> postMultipartData(
    String uri,
    Map<String, dynamic> body,
    List<MultipartBody> multipartBody, {
    Map<String, String>? headers,
    bool handleError = true,
  }) async {
    _logWithTimestamp("====> API REQUEST STARTED =====");
    try {
      // Print curl command (simplified for multipart)
      _logWithTimestamp('====> CURL COMMAND (MULTIPART):');
      _logWithTimestamp(_formatCurlCommand('POST', appBaseUrl + uri, headers));
      _logWithTimestamp('====> API Call: $uri');
      _logWithTimestamp('====> Headers: ${headers ?? mainHeaders}');
      _logWithTimestamp('====> Request Body: $body');
      _logWithTimestamp('====> Multipart Files: ${multipartBody.length} files');

      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      request.headers.addAll(headers ?? mainHeaders!);
      for (MultipartBody multipart in multipartBody) {
        if (multipart.file != null) {
          if (foundation.kIsWeb) {
            Uint8List list = await multipart.file!.readAsBytes();
            http.MultipartFile part = http.MultipartFile(
              multipart.key,
              multipart.file!.readAsBytes().asStream(),
              list.length,
              filename: basename(multipart.file!.path),
              contentType: MediaType('image', 'jpg'),
            );
            request.files.add(part);
            _logWithTimestamp(
                "====> File: ${multipart.key} = ${basename(multipart.file!.path)}");
          } else {
            File file = File(multipart.file!.path);
            request.files.add(http.MultipartFile(
              multipart.key,
              file.readAsBytes().asStream(),
              file.lengthSync(),
              filename: file.path.split('/').last,
            ));
            _logWithTimestamp(
                "====> File: ${multipart.key} = ${file.path.split('/').last}");
          }
        }
      }

      request.fields.addAll(body.map((key, value) {
        return MapEntry(key, value.toString());
      }));

      http.Response response =
          await http.Response.fromStream(await request.send());

      // Print response details
      _logWithTimestamp('====> RESPONSE STATUS: ${response.statusCode}');
      _logWithTimestamp('====> RESPONSE HEADERS: ${response.headers}');
      _logWithTimestamp('====> RESPONSE BODY: ${response.body}');

      _logWithTimestamp("====> API REQUEST COMPLETED =====");
      return handleResponse(response, uri, handleError);
    } catch (e) {
      _logWithTimestamp('====> API ERROR: $e');
      _logWithTimestamp("====> API REQUEST FAILED =====");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers, bool handleError = true}) async {
    _logWithTimestamp("====> API REQUEST STARTED =====");
    try {
      // Print curl command
      _logWithTimestamp('====> CURL COMMAND:');
      _logWithTimestamp(
          _formatCurlCommand('PUT', appBaseUrl + uri, headers, body));
      _logWithTimestamp('====> API Call: $uri');
      _logWithTimestamp('====> Headers: ${headers ?? mainHeaders}');
      _logWithTimestamp('====> Request Body: $body');
      _logWithTimestamp('====> API BaseUrl: $appBaseUrl');

      http.Response response = await http
          .put(
            Uri.parse(appBaseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      // Print response details
      _logWithTimestamp('====> RESPONSE STATUS: ${response.statusCode}');
      _logWithTimestamp('====> RESPONSE HEADERS: ${response.headers}');
      _logWithTimestamp('====> RESPONSE BODY: ${response.body}');

      _logWithTimestamp("====> API REQUEST COMPLETED =====");
      return handleResponse(response, uri, handleError);
    } catch (e) {
      _logWithTimestamp('====> API ERROR: $e');
      _logWithTimestamp("====> API REQUEST FAILED =====");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri,
      {Map<String, String>? headers, bool handleError = true}) async {
    _logWithTimestamp("====> API REQUEST STARTED =====");
    try {
      // Print curl command
      _logWithTimestamp('====> CURL COMMAND:');
      _logWithTimestamp(
          _formatCurlCommand('DELETE', appBaseUrl + uri, headers));
      _logWithTimestamp('====> API Call: $uri');
      _logWithTimestamp('====> Headers: ${headers ?? mainHeaders}');

      http.Response response = await http
          .delete(
            Uri.parse(appBaseUrl + uri),
            headers: headers ?? mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      // Print response details
      _logWithTimestamp('====> RESPONSE STATUS: ${response.statusCode}');
      _logWithTimestamp('====> RESPONSE HEADERS: ${response.headers}');
      _logWithTimestamp('====> RESPONSE BODY: ${response.body}');

      _logWithTimestamp("====> API REQUEST COMPLETED =====");
      return handleResponse(response, uri, handleError);
    } catch (e) {
      _logWithTimestamp('====> API ERROR: $e');
      _logWithTimestamp("====> API REQUEST FAILED =====");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(
      http.Response response, String uri, bool handleError) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {}

    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );

    // Enhanced logging for response processing
    _logWithTimestamp('====> RESPONSE PROCESSING:');
    _logWithTimestamp('====> Original Status: ${response.statusCode}');
    _logWithTimestamp('====> Processed Status: ${response0.statusCode}');
    _logWithTimestamp('====> Processed Body: ${response0.body}');
    _logWithTimestamp(
        '====> Processed Body Type: ${response0.body.runtimeType}');

    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      if (response0.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: errorResponse.errors![0].message);
        _logWithTimestamp(
            '====> Error Response Parsed: ${response0.statusText}');
      } else if (response0.body.toString().startsWith('{message')) {
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: response0.body['message']);
        _logWithTimestamp(
            '====> Message Response Parsed: ${response0.statusText}');
      }
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = const Response(statusCode: 0, statusText: noInternetMessage);
      _logWithTimestamp('====> Response Body is null, setting status to 0');
    }

    _logWithTimestamp('====> FINAL RESPONSE: [${response0.statusCode}] $uri');
    _logWithTimestamp('====> FINAL BODY: ${response0.body}');
    _logWithTimestamp('====> FINAL STATUS TEXT: ${response0.statusText}');

    if (handleError) {
      if (response0.statusCode == 200) {
        return response0;
      } else {
        ApiChecker.checkApi(response0);
        return const Response();
      }
    } else {
      return response0;
    }
  }
}

class MultipartBody {
  String key;
  XFile? file;

  MultipartBody({required this.key, this.file});
}
