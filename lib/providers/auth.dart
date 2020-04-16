import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _username;
  String _token;
  DateTime _expiryDate;

  bool get isAuth {
    return token != null;
  }

  String get username {
    return _username;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signUp(
      {@required String userId,
      @required String password,
      String email,
      String firstName,
      String lastName}) async {
    final url = '127.0.0.1:5000/api/register';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'username': userId,
            'password': password,
            'email': email,
            'firstName': firstName,
            'lastName': lastName,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
//        print(responseData['error']['message']);
        throw Exception(responseData['error']['message']);
      }
      _token = responseData['api'];
      _username = responseData['username'];
      _expiryDate = DateTime.now().add(Duration(hours: 1));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token,
        'userId': userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error){
      throw error;
    }
  }


  Future<void> login (String email , String password) async{
    final url = '127.0.0.1:5000/api/register';
    try {
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
      },),);
    }catch (error){
      throw Exception;
    }

  }
}
