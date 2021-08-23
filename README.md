## Which is?
**ShelfControllerFlowManager** is a utility package to handle the application's request and response flow, handling the normal application flow as well as the exception flow
## Usage

A simple usage example:
```dart
class PersonController {
  final ShelfRequestResponse2JsonUtility<Person> shelfRequestResponse2JsonUtility =  ShelfRequestResponse2JsonUtility<Person>(PersonFactory());
  final ShelfControllerFlowManager shelfControllerFlowManager = ShelfControllerFlowManager();

  @Route.post('/persons')
  FutureOr<Response> post(Request request) {
    return shelfControllerFlowManager.call(
      request: request,
      normalExecutionFlow: (request) async {
        final body = shelfRequestResponse2JsonUtility.body(request);
        return shelfRequestResponse2JsonUtility.ok(body);
      },
    );
  }
}
```

**Automatically** by default the function (callback) executed in the normal flow is invoked, 
in case of an exception depending on whether the exception thrown internally
is a BadRequestException, InternalServerErrorException or UnauthorizedException 
(Other exceptions will be programmed later) it will throw a different response json 
for each of the possible exceptions
#### Important
- All thrown exceptions must extend the ResponseException class
- It is possible to configure the call method with a custom ExceptionHandler, with its custom exceptions

```dart
class CustomException extends ErrorResponseException {
  CustomException() : super(444, message: 'Custom Exception');
}

class PersonController {
  final ShelfRequestResponse2JsonUtility<Person>
      shelfRequestResponse2JsonUtility =
      ShelfRequestResponse2JsonUtility<Person>(PersonFactory());
  final ShelfControllerFlowManager shelfControllerFlowManager =
      ShelfControllerFlowManager();

  @Route.post('/persons')
  FutureOr<Response> post(Request request) {
    return shelfControllerFlowManager.call(
      request: request,
      normalExecutionFlow: (request) async {
        final body = shelfRequestResponse2JsonUtility.body(request);
        return shelfRequestResponse2JsonUtility.ok(body);
      },
      onExceptionHandler: ExceptionHandler(
        {
          CustomException: (ErrorResponseException exception) async =>
              exception.response,
          ...ExceptionHandler.defaultHandlers,
        },
      ),
    );
  }
}

```

