class MovieModel {
  final int id;
  final String title;
  final String posterPath;
  final String originalTitle;
  final String originalLanguage;
  final String releaseDate;
  final String detail;
  const MovieModel(
      {required this.id,
      required this.title,
      required this.posterPath,
      required this.originalTitle,
      required this.originalLanguage,
      required this.releaseDate,
      required this.detail});
}
