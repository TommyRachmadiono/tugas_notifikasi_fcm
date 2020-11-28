import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
 static SharedPreferences pref;

  Future<void> initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<bool> isLogin() async {
    // pref = await SharedPreferences.getInstance();
    bool isLogin = pref.getBool('isLogin') ?? false;

    return isLogin;
  }

  static clearLoginData() async {
    pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  savePref({var key, var value}) async {
    var type = value.runtimeType;

    switch (type) {
      case String:
        pref.setString(key, value);
        break;
      case int:
        pref.setInt(key, value);
        break;
      case double:
        pref.setDouble(key, value);
        break;
      case bool:
        pref.setBool(key, value);
        break;
      default:
        return 'invalid data type';
        break;
    }

    return 'Berhasil menyimpan tipe data $type, dengan key $key dan value $value';
  }
}
