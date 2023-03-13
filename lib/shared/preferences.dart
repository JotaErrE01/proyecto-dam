import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;
  static String _token = '';
  static String _usuario = '';

  static Future init() async {
    return _prefs = await SharedPreferences.getInstance();
  }

  //toke - get y set 
  static String get token => _prefs.getString('key') ?? _token;
  static set token(String token) {
    _token = token;
    _prefs.setString('key', token);
  }

  //Usuario - get y set 
  static String get usuario => _prefs.getString('usuario') ?? _usuario;
  static set usuario(String usuario) {
    _usuario = usuario;
    _prefs.setString('usuario', usuario);
  }

}
