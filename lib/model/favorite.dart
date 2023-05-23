import 'package:flutter/material.dart';
import "SQL_helper.dart";


class Favorite {
  static Future<void> insertFavorite(int user_id, int movie_id) async {

    await DatabaseHelper.instance.insertFavorite(user_id, movie_id);
  }

  static Future<List<Map<String, dynamic>>> getFavorites(int user_id) async {
    return await DatabaseHelper.instance.getFavoritesByUserId(user_id);
  }
  
  static Future<void> deleteFavorite(int user_id, int movie_id) async {
    await DatabaseHelper.instance.deleteFavorite(user_id, movie_id);
  }

  static Future<bool> checkFavorite(int user_id, int movie_id) async {
    return await DatabaseHelper.instance.checkFavorite(user_id, movie_id);
  }
}
