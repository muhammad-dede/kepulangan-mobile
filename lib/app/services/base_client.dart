import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:kepulangan/app/services/storage_service.dart';

class BaseClient {
  static const String apiUrl = 'http://10.0.2.2:8000';
  // static const String apiUrl = 'https://kepulanganbp3mibanten.site/public';
  static const int timeOutDuration = 30;

  //----------------------GET----------------------
  Future<Either<String, dynamic>> get(String path) async {
    var uri = Uri.parse(apiUrl + path);
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${StorageService.to.read('token')}',
      "Content-Type": "application/json",
    };
    try {
      var response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: timeOutDuration));
      if (response.statusCode == 200) {
        var body = await jsonDecode(response.body);
        return Right(body);
      } else if (response.statusCode == 401) {
        await StorageService.to.remove('token');
        return _errorResponse(response);
      } else {
        return _errorResponse(response);
      }
    } catch (e) {
      return Left(ExceptionHandlers().getExceptionString(e));
    }
  }

  //----------------------POST----------------------
  Future<Either<String, dynamic>> post(String path, dynamic data) async {
    var uri = Uri.parse(apiUrl + path);
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${StorageService.to.read('token')}',
      "Content-Type": "application/json",
    };
    var body = jsonEncode(data);
    try {
      var response = await http
          .post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: timeOutDuration));
      if (response.statusCode == 200) {
        var body = await jsonDecode(response.body);
        return Right(body);
      } else if (response.statusCode == 401) {
        await StorageService.to.remove('token');
        return _errorResponse(response);
      } else {
        return _errorResponse(response);
      }
    } catch (e) {
      return Left(ExceptionHandlers().getExceptionString(e));
    }
  }

  //----------------------Post MultiPart----------------------

  Future<Either<String, dynamic>> postMultipart(
      String path, Map<String, dynamic>? body) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl + path));

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${StorageService.to.read('token')}',
        'Content-Type': "multipart/form-data",
      });

      if (body!.isNotEmpty) {
        for (var key in body.keys) {
          if (body[key] is List) {
            // List
            body[key].asMap().forEach((index, value) {
              return request.fields["$key[$index]"] = value.toString();
            });
          } else if (body[key] is File) {
            // File
            if (body[key] != null) {
              request.files.add(await http.MultipartFile.fromPath(
                  key, body[key].path.toString()));
            }
          } else {
            // int, string
            request.fields[key] = body[key].toString();
          }
        }
      }

      final response = await request.send();
      final responseJson = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var body = await jsonDecode(responseJson.body);
        return Right(body);
      } else if (response.statusCode == 401) {
        await StorageService.to.remove('token');
        return _errorResponse(responseJson);
      } else {
        return _errorResponse(responseJson);
      }
    } catch (e) {
      return Left(ExceptionHandlers().getExceptionString(e));
    }
  }

  //----------------------DELETE----------------------
  Future<Either<String, dynamic>> delete(String path) async {
    var uri = Uri.parse(apiUrl + path);
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${StorageService.to.read('token')}',
      "Content-Type": "application/json",
    };
    try {
      var response = await http
          .delete(uri, headers: headers)
          .timeout(const Duration(seconds: timeOutDuration));
      if (response.statusCode == 200) {
        var body = await jsonDecode(response.body);
        return Right(body);
      } else if (response.statusCode == 401) {
        await StorageService.to.remove('token');
        return _errorResponse(response);
      } else {
        return _errorResponse(response);
      }
    } catch (e) {
      return Left(ExceptionHandlers().getExceptionString(e));
    }
  }

  //----------------------ERROR STATUS CODES----------------------
  dynamic _errorResponse(http.Response response) {
    switch (response.statusCode) {
      case 400: //Bad request
        throw BadRequestException(jsonDecode(response.body)['message']);
      case 401: //Unauthorized
        throw UnAuthorizedException(jsonDecode(response.body)['message']);
      case 403: //Forbidden
        throw UnAuthorizedException(jsonDecode(response.body)['message']);
      case 404: //Resource Not Found
        throw NotFoundException(jsonDecode(response.body)['message']);
      case 500: //Internal Server Error
      default:
        throw FetchDataException(
            'Something went wrong! ${response.statusCode}');
    }
  }
}

//----------------------APP EXCEPTION----------------------
class AppException implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  AppException([this.message, this.prefix, this.url]);
}

//----------------------EXCEPTION HANDLER----------------------
class ExceptionHandlers {
  getExceptionString(error) {
    if (error is SocketException) {
      return 'No internet connection.';
    } else if (error is HttpException) {
      return 'HTTP error occured.';
    } else if (error is FormatException) {
      return 'Invalid data format.';
    } else if (error is TimeoutException) {
      return 'Request timeout.';
    } else if (error is BadRequestException) {
      return error.message.toString();
    } else if (error is UnAuthorizedException) {
      return error.message.toString();
    } else if (error is NotFoundException) {
      return error.message.toString();
    } else if (error is FetchDataException) {
      return error.message.toString();
    } else {
      return 'Unknown error occured.';
    }
  }
}

class BadRequestException extends AppException {
  BadRequestException([String? message, String? url])
      : super(message, 'Bad request', url);
}

class FetchDataException extends AppException {
  FetchDataException([String? message, String? url])
      : super(message, 'Unable to process the request', url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? message, String? url])
      : super(message, 'Api not responding', url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message, String? url])
      : super(message, 'Unauthorized request', url);
}

class NotFoundException extends AppException {
  NotFoundException([String? message, String? url])
      : super(message, 'Page not found', url);
}
