import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static final UserSharedPreferences _instance =
      new UserSharedPreferences._internal();

  factory UserSharedPreferences() {
    return _instance;
  }

  UserSharedPreferences._internal();

  SharedPreferences _preferences;

  initPreferences() async {
    this._preferences = await SharedPreferences.getInstance();
  }

  get userEmail {
    return _preferences.getString("user_email");
  }

  set userEmail(String value) {
    _preferences.setString("user_email", value);
  }

  get userPass {
    return _preferences.getString("user_pass");
  }

  set userPass(String value) {
    _preferences.setString("user_pass", value);
  }

  get userRoleTitle {
    return _preferences.getString("user_role_title");
  }

  set userRoleTitle(String value) {
    _preferences.setString("user_role_title", value);
  }

  get userName {
    return _preferences.getString("user_name");
  }

  set userName(String value) {
    _preferences.setString("user_name", value);
  }
}
