import 'package:flutter/material.dart';
import 'services/BaseNetwork.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_page/detail_movies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<dynamic> topMovies = [];
  List<dynamic> allMovies = [];
  List<dynamic> searchResults = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTopMovies();
    fetchAllMovies();
  }

  Future<List<dynamic>> getTopMovies() async {
    final url = Uri.parse('$BASE_URL/movie/top_rated?api_key=$API_KEY');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final results = jsonData['results'];
      return results;
    } else {
      throw Exception('Failed to load top movies');
    }
  }

  Future<List<dynamic>> getAllMovies() async {
    final url = Uri.parse('$BASE_URL/discover/movie?api_key=$API_KEY');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final results = jsonData['results'];
      return results;
    } else {
      throw Exception('Failed to load recent movies');
    }
  }

  Future<List<dynamic>> searchMovies(String query) async {
    final url =
        Uri.parse('$BASE_URL/search/movie?api_key=$API_KEY&query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final results = jsonData['results'];
      return results;
    } else {
      throw Exception('Failed to search movies');
    }
  }

  void fetchTopMovies() async {
    try {
      final movies = await getTopMovies();
      setState(() {
        topMovies = movies;
      });
    } catch (e) {
      print(e);
    }
  }

  void fetchAllMovies() async {
    try {
      final movies = await getAllMovies();
      setState(() {
        allMovies = movies;
      });
    } catch (e) {
      print(e);
    }
  }

  void searchMovie(String query) async {
    try {
      final results = await searchMovies(query);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print(e);
    }
  }

  void addToFavorites(int movie_id) async {
    int Userid = await getUserId() as int;
    if (Userid == -1) {
      Navigator.pushNamed(context, '/login');
    } else {
      
    }
  }
Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');
    // if (userId ==null) {
    //   userId = -1;
    // }
    return userId;
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[200],
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search movies',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => searchMovie(searchController.text),
            ),
          ),
          onSubmitted: (value) => searchMovie(value),
        ),
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
                  'Top Movies',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topMovies.length,
                  itemBuilder: (BuildContext context, int index) {
                    final movie = topMovies[index];
                    final id = movie['id'];
                    final title = movie['title'];
                    final posterPath = movie['poster_path'];
                    final originalTitle = movie['original_title'];
                    final originalLanguage = movie['original_language'];
                    final releaseDate = movie['release_date'];
                    final detail = movie['overview'];

                    return GestureDetector(
                      onTap: () => navigateToMovieDetail(id, title, posterPath,
                          originalTitle, originalLanguage, releaseDate, detail),
                      child: Container(
                        width: 120,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  '$imagePath$posterPath',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white, // Set text color to white
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
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
                itemCount: searchResults.length > 0
                    ? searchResults.length
                    : allMovies.length,
                itemBuilder: (BuildContext context, int index) {
                  final movie = searchResults.length > 0
                      ? searchResults[index]
                      : allMovies[index];
                  final id = movie['id'];
                  final title = movie['title'];
                  final posterPath = movie['poster_path'];
                  final originalTitle = movie['original_title'];
                  final originalLanguage = movie['original_language'];
                  final releaseDate = movie['release_date'];
                  final detail = movie['overview'];

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
