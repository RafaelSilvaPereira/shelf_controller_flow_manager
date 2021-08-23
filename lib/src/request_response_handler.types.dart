import 'dart:async';

import 'package:shelf/shelf.dart';

import 'response.exception.dart';

typedef RequestResponseHandler = FutureOr<Response> Function(Request request);
typedef OnErrorRequestResponseHandler = Future<Response> Function(
    ResponseException exception,
    );