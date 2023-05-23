import 'package:flutter/material.dart';
import "SQL_helper.dart";

class Auth {
  
  static Future<void> authRegisterUser({
    required String username,
    required String password,
  }) async {
    Map<String, dynamic> user = {
      'username': username,
      'password': password,
    };
    await DatabaseHelper.instance.insertUser(user);
  }

  static Future<int> authLoginUser({
    required String username,
    required String password,
  }) async {
    List<Map<String, dynamic>> users = await DatabaseHelper.instance.getUsers();
    for (var user in users) {
      if (user['username'] == username && user['password'] == password) {
        return user['id'];
      }
    }
    return -1;
  }
}