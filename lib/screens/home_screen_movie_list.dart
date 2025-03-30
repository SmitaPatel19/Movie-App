import 'package:flutter/material.dart';
import 'package:movie_app/screens/search_page.dart';
import 'package:movie_app/widgets/toprated.dart';
import 'package:movie_app/widgets/trending.dart';
import 'package:movie_app/widgets/tv.dart';
import '../model/movie_model.dart';
import '../utils/movie_service.dart';import '../utils/text.dart';
import 'favourites_list.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MovieService _movieService = MovieService();
  List<Movie> trendingMovies = [];
  List<Movie> topRatedMovies = [];
  List<Movie> tvShows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      final [trending, topRated, tv] = await Future.wait([
        _movieService.getTrendingMovies(),
        _movieService.getTopRatedMovies(),
        _movieService.getPopularTV(),
      ]);

      setState(() {
        trendingMovies = trending;
        topRatedMovies = topRated;
        tvShows = tv;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _toggleFavorite(Movie movie) async {
    await _movieService.toggleFavorite(movie.id.toString());
    setState(() {});
  }

   Future<bool> _isFavorite(Movie movie) async {
    final favorites = await _movieService.getFavorites();
    return favorites.contains(movie.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: ModifiedText(text: "Movie App"),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchPage(movies: [...trendingMovies, ...topRatedMovies, ...tvShows])),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoritesPage(movies: [...trendingMovies, ...topRatedMovies, ...tvShows])),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          TopRatedMovies(
            toprated: topRatedMovies,
            onFavoriteToggle: _toggleFavorite,
            isFavorite: _isFavorite,
          ),
          TrendingMovies(
            trending: trendingMovies,
            onFavoriteToggle: _toggleFavorite,
            isFavorite: _isFavorite,
          ),
          TVMovies(
            tv: tvShows,
            onFavoriteToggle: _toggleFavorite,
            isFavorite: _isFavorite,
          ),
        ],
      ),
    );
  }
}