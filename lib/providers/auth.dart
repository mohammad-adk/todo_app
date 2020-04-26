import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const GOOGLE_API_KEY = 'AIzaSyA1qYAga-fTYB1hmNO4qWq0an3b_sv17eI ';

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  String _username;
  String _firstName;
  String _lastName;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get userName {
    return _username;
  }

  String get firstName {
    return _firstName;
  }

  String get lastName {
    return _lastName;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signUp({
    @required String password,
    @required String email,
    @required String firstName,
    @required String lastName,
    @required String username,
  }) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$GOOGLE_API_KEY';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      saveUserInfo(username, firstName, lastName);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token,
        'userId': userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'username': _username,
        'firstname': _firstName,
        'lastname': _lastName,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> saveUserInfo(
      String username, String firstName, String lastName) async {
    final url2 =
        'https://todo-cfb1d.firebaseio.com/users/$_userId.json?auth=$token';
    print(username);
    print(firstName);
    print(lastName);
    try {
      final response = await http.put(url2,
          body: json.encode(
            {
              'username': username,
              'firstname': firstName,
              'lastname': lastName,
            },
          ));
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }
      _firstName = firstName;
      _lastName = lastName;
      _username = username;
    } catch (error) {
      print(error);
    }
  }

  Future<void> login(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$GOOGLE_API_KEY';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }
      final url2 =
          'https://todo-cfb1d.firebaseio.com/users/${responseData['localId']}.json?auth=${responseData['idToken']}';
      final response2 = await http.get(url2);
      final responseData2 = json.decode(response2.body);
      if (responseData2['error'] != null) {
        throw Exception(responseData2['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _username = responseData2['username'];
      _firstName = responseData2['firstname'];
      _lastName = responseData2['lastname'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token,
        'userId': userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'username': _username,
        'firstname': _firstName,
        'lastname': _lastName,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw Exception;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (!extractedUserData.containsKey('token')) {
      return false;
    }
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _username = extractedUserData['username'];
    _firstName = extractedUserData['firstname'];
    _lastName = extractedUserData['lastname'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
