import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_project_akhir_1/model/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/SQL_helper.dart';
import 'services/BaseNetwork.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/favorite.dart';
import 'detail_page/detail_movies.dart';
import 'package:auto_reload/auto_reload.dart';


class FavoriteMovie {
  final int id;

  FavoriteMovie({required this.id});
}

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<dynamic> favorites = [];
  List<dynamic> favoritesId = [];
  List<dynamic> movieFavorites = [];
  List<MovieModel> tesMovieModel = [];

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');
    // if (userId ==null) {
    //   userId = -1;
    // }
    return userId;
  }

  Future<List> _getFavorites() async {
    int? userId = await getUserId();
    if (userId == null) {
      //kosong
    } else {
      List<Movie> getFavorites = await Favorite.getFavorites(userId);
      //print('getFavorites: $getFavorites');
      return await getAllFavorites(getFavorites);
    }
    return [];
  }

  Future<List<dynamic>> getAllFavorites(getFavorites) async {
    //print('getAllFavorites: $getFavorites');
    //final List<FavoriteMovie> favoriteMovies = getFavorites.map((map) => FavoriteMovie(movieId: map['movieid'])).toList();
    if (getFavorites.length > 0) {
      for (var favorite in getFavorites) {
        var id_movie = favorite.getterId();

        final url = Uri.parse('$BASE_URL/movie/$id_movie?api_key=$API_KEY');
        final response = await http.get(url);

        final jsonData = json.decode(response.body);
        //print(jsonData);
        //final results = jsonData['original_title'];
        //final originalTitle
        //final {id, title, posterPath, originalTitle, originalLanguage, releasedDate,detail} = jsonData;
        //final results = MovieModel(id: jsonData['id'], title: jsonData['title'], posterPath: jsonData['posterPath'], originalTitle: jsonData['originalTitle'], originalLanguage: jsonData['originalLanguage'], releaseDate: jsonData['releaseDate'], detail: jsonData['detail']);

        //print('results: $results');
        setState(){
        tesMovieModel.add(MovieModel(
            id: jsonData['id'],
            title: jsonData['title'],
            posterPath: jsonData['poster_path'],
            originalTitle: jsonData['original_title'],
            originalLanguage: jsonData['original_language'],
            releaseDate: jsonData['release_date'],
            detail: jsonData['overview']));
        }
      }
      
      print("id ");
      print(tesMovieModel[0]);
      
    }
    return tesMovieModel;
  }

  

  

  void navigateToMovieDetail(
      int id,
      String title,
      String posterPath,
      String originalTitle,
      String originalLanguage,
      String releaseDate,
      String detail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(
          id: id,
          title: title,
          posterPath: posterPath,
          originalTitle: originalTitle,
          originalLanguage: originalLanguage,
          releaseDate: releaseDate,
          overview: detail,
        ),
      ),
    );
  }
  Future onRefresh() async {
    //_getFavorites();
  }
  @override
  void initState() {
    super.initState();
    
    
    _getFavorites();
    
    //startAutoReload();
  }

  @override
  Widget build(BuildContext context) {
    //_getFavorites();
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Movies', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.grey[200],
      ),
      body: Container(
        height: screenHeight,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Movies List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),          
              SizedBox(
                height: 20,
              ),
              RefreshIndicator(onRefresh: _getFavorites,child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tesMovieModel.length,
                itemBuilder: (BuildContext context, int index) {
                  final movie = tesMovieModel[index];
                  print('movie');
                  print(movie);
                  print('movie 144: $movieFavorites');

                  final id = movie.id;
                  final title = movie.title;
                  final posterPath = movie.posterPath;
                  final originalTitle = movie.originalTitle;
                  final originalLanguage = movie.originalLanguage;
                  final releaseDate = movie.releaseDate;
                  final detail = movie.detail;

                  return ListTile(
                    leading: Image.network(
                      '$imagePath$posterPath',
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                    onTap: () => navigateToMovieDetail(id, title, posterPath,
                        originalTitle, originalLanguage, releaseDate, detail),
                    // trailing: IconButton(
                    //   icon: Icon(Icons.favorite_border),
                    //   onPressed: addToFavorites(id),
                    // ),
                  );
                },
              ),),
              
            ],
          ),
        ),
      ),
    );
  }
}
