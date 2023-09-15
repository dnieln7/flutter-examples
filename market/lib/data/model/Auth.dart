import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:market/service/ApiConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expireAt;
  Timer logOutTimer;

  String get id => _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expireAt != null &&
        _expireAt.isAfter(DateTime.now())) {
      return _token;
    }

    return null;
  }

  Future<void> signUp(String email, String password) async {
    final String requestUrl = ApiConfig.sign_up_url;
    final body = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    try {
      final response = await http.post(requestUrl, body: json.encode(body));
      final decoded = json.decode(response.body);

      if (decoded['error'] != null) {
        throw Exception(decoded['error']['message']);
      }

      _userId = decoded['localId'];
      _token = decoded['idToken'];
      _expireAt = DateTime.now().add(
        Duration(seconds: int.parse(decoded['expiresIn'])),
      );

      final preferences = await SharedPreferences.getInstance();

      preferences.setString("ID", _userId);
      preferences.setString("TOKEN", _token);
      preferences.setString("EXPIRE", _expireAt.toIso8601String());

      autoLogOut();

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    final String requestUrl = ApiConfig.login_url;
    final body = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    try {
      final response = await http.post(requestUrl, body: json.encode(body));
      final decoded = json.decode(response.body);

      if (decoded['error'] != null) {
        throw Exception(decoded['error']['message']);
      }

      _userId = decoded['localId'];
      _token = decoded['idToken'];
      _expireAt = DateTime.now().add(
        Duration(seconds: int.parse(decoded['expiresIn'])),
      );

      final preferences = await SharedPreferences.getInstance();

      preferences.setString("ID", _userId);
      preferences.setString("TOKEN", _token);
      preferences.setString("EXPIRE", _expireAt.toIso8601String());

      autoLogOut();

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logOut() async {
    _token = null;
    _expireAt = null;
    _userId = null;

    if (logOutTimer != null) {
      logOutTimer.cancel();
      logOutTimer = null;
    }

    final preferences = await SharedPreferences.getInstance();

    preferences.clear();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();

    if (!preferences.containsKey("ID")) {
      return false;
    }

    final expireDate = DateTime.parse(preferences.getString("EXPIRE"));

    if (expireDate.isBefore(DateTime.now())) {
      return false;
    }

    _userId = preferences.getString("ID");
    _token = preferences.getString("TOKEN");
    _expireAt = DateTime.parse(preferences.getString("EXPIRE"));

    autoLogOut();
    notifyListeners();

    return true;
  }

  void autoLogOut() {
    if (logOutTimer != null) {
      logOutTimer.cancel();
    }

    final diff = _expireAt.difference(DateTime.now()).inSeconds;
    logOutTimer = Timer(Duration(seconds: diff), () => logOut());
  }
}
