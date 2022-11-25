// ignore_for_file: prefer_typing_uninitialized_variables

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix $_message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, 'Error During Conmutication:');
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'Invalid Request:');
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message]) : super(message, 'Invalid input:');
}
class ForbiddenException extends AppException {
  ForbiddenException([String? message]) : super(message, 'Forbidden:');
}

class NotFound extends AppException {
  NotFound([String? message]) : super(message,"Not found");
}

class Conflict extends AppException {
  Conflict([String? message]) : super(message, "Error due to a conflic");
}
class BadGateway extends AppException {
  BadGateway([String? message]) : super(message, "Bad gateway");
}

