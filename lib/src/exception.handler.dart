import 'dart:async';

import 'package:shelf/shelf.dart';

import 'response.exception.dart';
import 'request_response_handler.types.dart';

class ExceptionHandler {
  static final Map<Type, OnErrorRequestResponseHandler> handlers =
      <Type, OnErrorRequestResponseHandler>{
    BadRequestException: (ResponseException exception) async =>
        exception.response,
    InternalServerErrorException: (ResponseException exception) async =>
        exception.response,
    UnauthorizedException: (ResponseException exception) async =>
        exception.response,
  };

  final Map<Type, OnErrorRequestResponseHandler> handlerWithException;

  final Response defaultResponse = InternalServerErrorException().response;

  ExceptionHandler(this.handlerWithException);

  factory ExceptionHandler.build() {
    return ExceptionHandler(handlers);
  }

  FutureOr<Response> handle(
      Type exceptionType, ResponseException exception) async {
    final handlerWithException2 = handlerWithException[exceptionType];
    if (handlerWithException2 != null) {
      return handlerWithException2(exception);
    } else {
      return defaultResponse;
    }
  }
}
