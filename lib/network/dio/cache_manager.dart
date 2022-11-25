import 'dio_helper.dart';
///Cache management.
class CacheManager {
  
  ///Clear all cache.
  Future<bool> clearAllCache() {
    Future<bool> isclear;
    isclear = DioHelper().getCacheManager().clearAll();
    return isclear;
  }


  ///Clear by url. \
  ///requestMethod > Your request api in uppercase. Ex.,GET POST (Uppercase) \
  ///url > Your url.
  Future<bool> clearByUrl(
      {required String requestMethod, required String url}) {
    Future<bool> isclear;
    isclear = DioHelper()
        .getCacheManager()
        .deleteByPrimaryKey(url, requestMethod: requestMethod);
    return isclear;
  }

  ///Clear by url and path. \
  ///requestMethod >Your request api in uppercase. Ex.,GET POST (Uppercase) \
  /// url > Your base url.\
  /// path > your path.\
  /// queryParameters > Your queryParameters.\
  /// data > Your data
  Future<bool> clearByUrlAndPath(
      {required String requestMethod,
      required String url,
      required String path,
      Map<String, dynamic>? queryParameters,
      dynamic data}) {
    Future<bool> isclear;
    isclear = DioHelper().getCacheManager().deleteByPrimaryKeyAndSubKey(url,
        requestMethod: requestMethod,
        subKey: path,
        queryParameters: queryParameters,
        data: data);
    return isclear;
  }
}
