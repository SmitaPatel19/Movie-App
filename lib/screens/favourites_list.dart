import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../model/movie_model.dart';
import '../utils/movie_service.dart';
import '../widgets/movie_card.dart';


class FavoritesPage extends StatefulWidget {
  final List<Movie> movies;

  const FavoritesPage({super.key, required this.movies});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final MovieService _movieService = MovieService();
  late List<Movie> favoriteMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favoriteIds = await _movieService.getFavorites();
    setState(() {
      favoriteMovies = widget.movies.where((m) => favoriteIds.contains(m.id.toString())).toList();
      isLoading=false;
    });
  }

  Future<void> _toggleFavorite(Movie movie) async {
    await _movieService.toggleFavorite(movie.id.toString());
    await _loadFavorites(); // Refresh the list after toggling
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: favoriteMovies.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : RefreshIndicator(
        onRefresh: _loadFavorites,
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    child: MovieCard(
                      movie: movie,
                      onFavoriteToggle: () => _toggleFavorite(movie),
                      isFavorite: true, // Since we're in favorites page
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}