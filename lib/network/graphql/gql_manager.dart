// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:core/network/sharedPref/service.dart';

class GqlCacheManager {
  ///For cache data
  final BaseSharedPreference _baseSharedPreference = BaseSharedPreference();

  Future<void> cacheData(var data, String key, Duration? cacheDuration) async {
    String json = jsonEncode(data);
    //set Duration เพิ่มด้วย
    await _baseSharedPreference.setString(key, json);
    if (cacheDuration != null) {
      cacheInterval(key, cacheDuration);
    }
  }

  ///get cache
  getCacheManager(String key) async {
    var x = await _baseSharedPreference.getString(key);
    Map<String, dynamic> map = jsonDecode(x);
    print('get cache data = $map');
    return map;
  }

//Remove cache
  ///[key] String queries should be used as keys.
  gqlRemoveCache(String key) async {
    await _baseSharedPreference.remove(key);
    return true;
  }

  // gqlClearCacheAll() async {
  //   await _baseSharedPreference.clear();
  //   return true;
  // }

  /// loop for remove cache
  cacheInterval(String key, Duration duration) async {
    var hasKey = await _baseSharedPreference.containsKey(key);
    if (hasKey) {
      Future.delayed(
        duration,
        () async {
          gqlRemoveCache(key);
          print('clear cache');
        },
      );
    }
  }
}
