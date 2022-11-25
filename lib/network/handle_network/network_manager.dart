import 'package:core/network/handle_network/app_exception.dart';
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NetworkManager {
  late String message;
  NetworkManager.fromDioError(e) {
    //ใส่ datatype ให้ตัวแปลที่รับมา
    DioError dioError = e;
    //เช็ค Status ต่างๆ
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        message = handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioErrorType.other:
        if (dioError.message.contains("SocketException")) {
          message = 'No Internet';
          break;
        }
        message = "Unexpected error occurred";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  NetworkManager.fromGqlError(QueryResult queryResult) {
    if (queryResult.exception?.linkException is HttpLinkServerException) {
      HttpLinkServerException httpLink =
          queryResult.exception?.linkException as HttpLinkServerException;
      if (httpLink.parsedResponse?.errors?.isNotEmpty == true) {
        message = handleError(
          httpLink.response.statusCode,
          httpLink.parsedResponse?.errors?.first.message,
        );
      }
    }
    if (queryResult.exception?.linkException is NetworkException) {
      NetworkException networkException =
          queryResult.exception?.linkException as NetworkException;
      message = ('NetworkException : ${networkException.message}');
    }
    if (queryResult.exception?.linkException is ServerException) {
      ServerException serverException =
          queryResult.exception?.linkException as ServerException;
      message =
          ('ServerException : ${serverException.originalException.message}');
    }
  }

  String handleError(int? statusCode, dynamic error) {
    String errorMessage = error.toString();
    switch (statusCode) {
      case 400:
        return BadRequestException(errorMessage).toString();
      case 401:
        return UnauthorisedException(errorMessage).toString();
      case 403:
        return ForbiddenException(errorMessage).toString();
      case 404:
        return NotFound(errorMessage).toString();
      case 409:
        return Conflict(errorMessage).toString();
      case 500:
        return FetchDataException(
                'Error occured while communication with server with status code : $errorMessage')
            .toString();
      case 502:
        return BadGateway(errorMessage).toString();
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
