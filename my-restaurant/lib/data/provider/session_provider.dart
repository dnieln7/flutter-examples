import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:my_restaurant/utils/preferences_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionProvider with ChangeNotifier {
  String _role;
  String _token;
  DateTime _expireAt;
  Timer _logOutTimer;

  bool get isAuth => token != null;

  String get token {
    if (_token != null &&
        _expireAt != null &&
        _expireAt.isAfter(DateTime.now())) {
      return _token;
    }

    return null;
  }

  String get role => '$_role';

  void login(String token, String role) {
    _role = role;
    _token = token;
    _expireAt = DateTime.now().add(Duration(minutes: 20));
    PreferencesUtils.setSession(
      _token,
      _role,
      _expireAt.toIso8601String(),
    );

    notifyListeners();
    autoLogOut();
  }

  void logOut() {
    _token = null;
    _expireAt = null;
    _role = null;

    if (_logOutTimer != null) {
      _logOutTimer.cancel();
      _logOutTimer = null;
    }

    PreferencesUtils.deleteSession();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('TOKEN')) {
      return false;
    }

    final expireDate = DateTime.parse(prefs.getString('EXPIRE'));

    if (expireDate.isBefore(DateTime.now())) {
      return false;
    }

    _role = prefs.getString('ROLE');
    _token = prefs.getString('TOKEN');
    _expireAt = DateTime.parse(prefs.getString('EXPIRE'));

    notifyListeners();
    autoLogOut();

    return true;
  }

  void autoLogOut() {
    if (_logOutTimer != null) {
      _logOutTimer.cancel();
    }

    final diff = _expireAt.difference(DateTime.now()).inMinutes;
    _logOutTimer = Timer(Duration(minutes: diff), () => logOut());
  }
}
