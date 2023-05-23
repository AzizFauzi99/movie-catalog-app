import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/SQL_helper.dart';
import 'services/BaseNetwork.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/favorite.dart';
import 'detail_page/detail_movies.dart';

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
  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');
    // if (userId ==null) {
    //   userId = -1;
    // }
    return userId;
  }

  void _getFavorites() async {
    int? userId = await getUserId();
    if (userId == null) {
      //kosong
    } else {
      List<Map<String, dynamic>> getFavorites =
          await Favorite.getFavorites(userId);
      //print('getFavorites: $getFavorites');
      final film = await getAllFavorites(getFavorites);
      //print(getFavorites);
      //print('film: $film');
      // Get the user id from shared preferences

      // Get the favorites from the database
      // final results = await Auth.authGetFavorites();
      // setState(() {
      //   favorites = results;
      // });

    }
  }

  Future<List<dynamic>> getAllFavorites(getFavorites) async {
    //print('getAllFavorites: $getFavorites');
    //final List<FavoriteMovie> favoriteMovies = getFavorites.map((map) => FavoriteMovie(movieId: map['movieid'])).toList();

    for (var favorite in getFavorites) {
      //print("favorite: "+favorite.movie_id);
      // print("favorite");
      // //print(TypedData(favorite));
      // print(favorite.runtimeType);
      //final {movie_id} = favorite;

      var id_movie = favorite['movie_id'];
      final url = Uri.parse('$BASE_URL/movie/$id_movie?api_key=$API_KEY');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'];
        favorites.add(results);
      } else {
        throw Exception('Failed to load top movies');
      }
    }
    //print('favorites: $favorites');
    return favorites;
  }

  void getAllFavoritesMovies() {}

  // void fetchFavorites() async {
  //   //_getFavorites();
  //   if (favorites.length == 0) {
  //     final results = _getFavorites();

  //     setState(() {
  //       favorites = results;
  //     });
  //   }
  // }

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

  @override
  void initState() {
    _getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final movies = _getFavorites();
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Movies'),
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
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: favorites.length,
                itemBuilder: (BuildContext context, int index) {
                  final movie = favorites;
                  //print('movie 144: $movie');
                  // if (movie.length > 0) {
                  //   final id = movie['id'];
                  //   final title = movie['title'];
                  // final posterPath = movie['poster_path'];
                  //   final originalTitle = movie['original_title'];
                  //   final originalLanguage = movie['original_language'];
                  //   final releaseDate = movie['release_date'];
                  //   final detail = movie['overview'];
                  // }

                  // return ListTile(
                  //   leading: Image.network(
                  //     '$imagePath$posterPath',
                  //     width: 50,
                  //     height: 75,
                  //     fit: BoxFit.cover,
                  //   ),
                  //   title: Text(
                  //     title,
                  //     style: TextStyle(
                  //       color: Colors.white, // Set text color to white
                  //     ),
                  //   ),
                  //   onTap: () => navigateToMovieDetail(id, title, posterPath,
                  //       originalTitle, originalLanguage, releaseDate, detail),
                  //   // trailing: IconButton(
                  //   //   icon: Icon(Icons.favorite_border),
                  //   //   onPressed: addToFavorites(id),
                  //   // ),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
