// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesHelper {
//   static final String _offline_cache_key = 'programmingLanguageListResponse';

//   static Future<ProgrammingLanguageList> getCache() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final cache = prefs.getString(_offline_cache_key);
//     final offlineData =
//         cache != null ? programmingLanguageListFromJson(cache) : null;

//     return offlineData;
//   }

//   static Future<bool> setCache(dynamic value) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();

//     return prefs.setString(_offline_cache_key, jsonEncode(value));
//   }
// }