import 'package:core/network/utils/function.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:encrypt/encrypt.dart';

///In DioHelper() there is a default baseURI and header.
///If you don't use the default baseURl and header, you can send the value in the parameter of DioHelper().
class DioHelper {
  Dio? _dio;
  static DioCacheManager? _manager;
  static const _baseUrl = "https://633126483ea4956cfb57ab52.mockapi.io/";

  final String? baseUrl;
  final Map<String, String>? headers;
  DioHelper({Key? key, this.baseUrl, this.headers});
  
  //Check the cache and return Dio network.
  ///isCache > Do you need cache? \
  ///true: caches.\
  ///false: does not cache. 
  Dio dioClient({required bool isCache}) {
    if (isCache == true) {
      _dio ??= Dio(BaseOptions(
        baseUrl: baseUrl.toString() == 'null' ? _baseUrl : baseUrl!,
        headers: setHeader(headers),
      ))
        ..interceptors.add(getCacheManager().interceptor)
        ..interceptors.add(LogInterceptor(responseBody: true));
      return _dio!;
    } else {
      _dio ??= Dio(BaseOptions(
        baseUrl: baseUrl.toString() == 'null' ? _baseUrl : baseUrl!,
        headers: setHeader(headers),
      ));
      return _dio!;
    }
  }
  

  DioCacheManager getCacheManager() {
    _manager ??= DioCacheManager(CacheConfig(
      baseUrl: baseUrl,
    ));
    return _manager!;

  }
}
