// ignore_for_file: prefer_function_declarations_over_variables

import 'package:shared_preferences/shared_preferences.dart';

///```
/// example use sharedpreference
/// await baseSharedPreference.setString('keydata', 'valuedata');
/// await baseSharedPreference.getString('keydata);
/// await baseSharedPreference.remove('keydata');
/// await baseSharedPreference.clear();
///```
class BaseSharedPreference {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  getBool(key) async {
    await init();
    var boolData = _preferences!.getInt(key);
    return boolData;
  }

  getInt(key) async {
    await init();
    var intData = _preferences!.getInt(key);
    return intData;
  }

  getDouble(key) async {
    await init();
    var doubleData = _preferences!.getDouble(key);
    return doubleData;
  }

  getString(key) async {
    await init();
    var stringData = _preferences!.getString(key);
    return stringData;
  }

  setInt(key, int value) async {
    await init();
    _preferences!.setInt(key, value);
  }

  setDouble(key, double value) async {
    await init();
    _preferences!.setDouble(key, value);
  }

  setBool(key, bool value) async {
    await init();
    _preferences!.setBool(key, value);
  }

  setString(key, String value) async {
    await init();
    _preferences!.setString(key, value);
  }

  remove(key) async {
    await init();
    _preferences!.remove(key);
  }

  clear() async {
    await init();
    _preferences!.clear();
  }

  containsKey(key) async {
    await init();
    var data = _preferences!.containsKey(key);
    return data;
  }
}
