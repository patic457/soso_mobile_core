
// ignore_for_file: constant_identifier_names

class ApiResponse<T> {
  Status status;
  T? data;
  String? message;

  ApiResponse.initial(this.message) : status = Status.INITIAL;
  ApiResponse.loading(this.message) : status = Status.LOADING;
  ApiResponse.complete(this.data) : status = Status.COMPLETE;
  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return 'Status : $status /n Message : $message /n Data : $data';
  }
}

enum Status { INITIAL, LOADING, COMPLETE, ERROR }