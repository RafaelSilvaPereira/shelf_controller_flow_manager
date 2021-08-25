import 'dart:convert';

import 'package:shelf/shelf.dart';

class HttpExceptionStatus {
  static const int BAD_REQUEST = 400;
  static const int UNAUTHORIZED = 401;
  static const int INTERNAL_SERVER_ERROR = 500;
}

abstract class ResponseException implements Exception {
  final DateTime timestamp = DateTime.now();
  final int statusCode;
  final String? message;
  final Map<String, String>? optionalMessages;

  ResponseException(
    this.statusCode, {
    this.optionalMessages,
    this.message,
  });

  Response get response => Response(
        statusCode,
        body: responseBody,
        headers: {
          'content-Type': 'application/json',
        },
      );

  String get responseBody {
    final responseBody = <String, String>{
      'timestamp': timestamp.toIso8601String(),
      'message': message ?? ''
    };
    if (optionalMessages != null) {
      responseBody.addAll(optionalMessages!);
    }

    return jsonEncode(responseBody);
  }
}

class BadRequestException extends ResponseException {
  BadRequestException({
    String? message,
    Map<String, String>? optionalMessages,
  }) : super(
          HttpExceptionStatus.BAD_REQUEST,
          message: 'Bad Request: $message',
          optionalMessages: optionalMessages,
        );
}

class InternalServerErrorException extends ResponseException {
  InternalServerErrorException({
    String? message,
    Map<String, String>? optionalMessages,
  }) : super(
          HttpExceptionStatus.INTERNAL_SERVER_ERROR,
          message: 'Internal Server Error: $message',
          optionalMessages: optionalMessages,
        );
}

class UnauthorizedException extends ResponseException {
  UnauthorizedException({
    String? message,
    Map<String, String>? optionalMessages,
  }) : super(
          HttpExceptionStatus.INTERNAL_SERVER_ERROR,
          message: 'Unauthorized: $message',
          optionalMessages: optionalMessages,
        );
}
