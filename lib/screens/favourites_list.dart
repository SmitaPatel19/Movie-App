import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../model/movie_model.dart';
import '../utils/movie_service.dart';
import '../utils/text.dart';
import '../widgets/movie_card.dart';

class FavoritesPage extends StatefulWidget {
  final List<Movie> movies;

  const FavoritesPage({super.key, required this.movies});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final MovieService _movieService = MovieService();
  List<Movie> favoriteMovies = []; // Removed late initialization
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favoriteIds = await _movieService.getFavorites();
      setState(() {
        favoriteMovies = widget.movies
            .where((m) => favoriteIds.contains(m.id.toString()))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _toggleFavorite(Movie movie) async {
    try {
      await _movieService.toggleFavorite(movie.id.toString());
      await _loadFavorites(); // Refresh the list after toggling
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_left,
            color: Colors.white,
            size: 35,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const ModifiedText(text: "Favorites"),
      ),
      body: favoriteMovies.isEmpty
          ? const Center(
        child: ModifiedText(
          text: "No favorites yet",
          size: 15,
        ),
      )
          : RefreshIndicator(
        color: Colors.white,
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
                      onFavoriteToggle: (m) => _toggleFavorite(m),
                      isFavorite: (_) async => true, // Always true in favorites page
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