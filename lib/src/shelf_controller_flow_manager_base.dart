import 'dart:async';

import 'package:shelf/shelf.dart';
import 'response.exception.dart';

import 'exception.handler.dart';
import 'request_response_handler.types.dart';


class ShelfControllerFlowManager {
  final ExceptionHandler onExceptionHandler;

  ShelfControllerFlowManager() : onExceptionHandler = ExceptionHandler.build();

  FutureOr<Response> call({
    required Request request,
    required RequestResponseHandler normalExecutionFlow,
    ExceptionHandler? onExceptionHandler,
  }) async {
    try {
      return await normalExecutionFlow(request);
    } on ResponseException catch (exception) {
      if (onExceptionHandler != null) {
        return onExceptionHandler.handle(exception.runtimeType, exception);
      } else {
        return this.onExceptionHandler.handle(exception.runtimeType, exception);
      }
    }
  }
}
