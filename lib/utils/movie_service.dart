import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmdb_api/tmdb_api.dart';
import '../model/movie_model.dart';

class MovieService {
  final String apikey = 'f3fbd4ac3d822a470a38cb60665b82aa';
  final readaccesstoken = 'eyJhbGci...';

  Future<List<Movie>> getTrendingMovies() async {
    final tmdb = TMDB(ApiKeys(apikey, readaccesstoken));
    final result = await tmdb.v3.trending.getTrending();
    return (result['results'] as List).map((m) => Movie.fromJson(m)).toList();
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final tmdb = TMDB(ApiKeys(apikey, readaccesstoken));
    final result = await tmdb.v3.movies.getTopRated();
    return (result['results'] as List).map((m) => Movie.fromJson(m)).toList();
  }

  Future<List<Movie>> getPopularTV() async {
    final tmdb = TMDB(ApiKeys(apikey, readaccesstoken));
    final result = await tmdb.v3.tv.getPopular();
    return (result['results'] as List).map((m) => Movie.fromJson(m)).toList();
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }

  Future<void> toggleFavorite(String movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (favorites.contains(movieId)) {
      favorites.remove(movieId);
    } else {
      favorites.add(movieId);
    }
    await prefs.setStringList('favorites', favorites);
  }
}