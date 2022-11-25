import 'dart:io' show Platform;

import 'package:core/network/utils/function.dart';

String baseUrlApi = "https://633126483ea4956cfb57ab52.mockapi.io/";
String graphqlEndpoint = "https://graphqlzero.almansi.me/api";
String sesion = Platform.isAndroid
    ? sesion = 'android-${DateTime.now()}${generateRandomString(10)}'
    : sesion = 'ios-${DateTime.now()}${generateRandomString(10)}';

Map<String, String> baseHeaders = {
  "Accept": "application/json",
  "Content-Type": "application/json; charset=utf-8",
  // "X-sesion-id": sesion
  // "Authorization": "Bearer ${("TOKEN")}",
};
