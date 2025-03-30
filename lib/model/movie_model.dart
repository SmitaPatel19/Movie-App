class Movie {
  final int id;
  final String title;
  final String? poster_path;
  final String? overview;
  final double? voteAverage;
  final String? release_date;
  final String? backdrop_path;

  Movie({
    required this.id,
    required this.title,
    this.poster_path,
    this.overview,
    this.voteAverage,
    this.release_date,
    this.backdrop_path,
  });

  String get posterUrl => poster_path != null
      ? 'https://image.tmdb.org/t/p/w500$poster_path'
      : 'https://via.placeholder.com/150';

  String get backdropUrl => backdrop_path != null
      ? 'https://image.tmdb.org/t/p/w500$backdrop_path'
      : 'https://via.placeholder.com/150';

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? 'Unknown',
      poster_path: json['poster_path'],
      overview: json['overview'],
      voteAverage: json['vote_average']?.toDouble(),
      release_date: json['release_date'],
      backdrop_path: json['backdrop_path'],
    );
  }
}