import 'package:flutter/material.dart';
import '../home_page.dart';
import '../services/BaseNetwork.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/SQL_helper.dart';
import '../model/favorite.dart';

bool isFavorite = false;

class MovieDetailPage extends StatefulWidget {
  final int id;
  final String title;
  final String posterPath;
  final String originalTitle;
  final String originalLanguage;
  final String releaseDate;
  final String overview;

  const MovieDetailPage({
    Key? key,
    required this.id,
    required this.title,
    required this.posterPath,
    required this.originalTitle,
    required this.originalLanguage,
    required this.releaseDate,
    required this.overview,
  }) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');
    // if (userId ==null) {
    //   userId = -1;
    // }
    return userId;
  }

  void addToFavorites(int movie_id) async {
    int Userid = await getUserId() as int;
    if (Userid == -1) {
      //Navigator.pushNamed(context, '/login');
    } else {
      await Favorite.insertFavorite(Userid, movie_id);
    }
    List favorite = await Favorite.getFavorites(Userid);
    
    print(favorite);
    print("Success Add");
  }

  void deleteFavorite(int movie_id) async {
    int Userid = await getUserId() as int;
    if (Userid == -1) {
      //Navigator.pushNamed(context, '/login');
    } else {
      await Favorite.deleteFavorite(Userid, movie_id);
    }
    
    // List favorite = await Favorite.getFavorites(Userid);
    // print(favorite);
    print("Success Delete");
  }

  void getFavorite() async {
    int Userid = await getUserId() as int;
    if (Userid == -1) {
      //Navigator.pushNamed(context, '/login');
    } else {
      isFavorite = await Favorite.checkFavorite(Userid, widget.id);
    }
    // List favorite = await Favorite.getFavorites(Userid);
    // print(favorite);
    print(isFavorite);
    print("Success get Favorite");
    setState(() {
      isFavorite = isFavorite;
    });
  }

  @override
  void initState() {
    super.initState();
    getFavorite();
    //isFavorite = getFavorite(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (isFavorite) {
                    deleteFavorite(widget.id);
                  } else {
                    addToFavorites(widget.id);
                  }
                  isFavorite = !isFavorite;
                });
              },
              icon: (isFavorite)
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border)),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                '$imagePath${widget.posterPath}',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Original Title: ${widget.originalTitle}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Original Language: ${widget.originalLanguage}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Release Date: ${widget.releaseDate}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.overview,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
