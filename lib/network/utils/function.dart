import 'dart:math';

import 'package:core/network/utils/constant.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

Map<String, String> setHeader(Map<String, String>? headers) =>
    headers = headers ?? baseHeaders;

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
