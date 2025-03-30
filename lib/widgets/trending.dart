import 'package:flutter/material.dart';
import '../model/movie_model.dart';
import '../screens/movie_description.dart';

class TrendingMovies extends StatefulWidget {
  final List<Movie> trending;
  final Function(Movie) onFavoriteToggle;
  final Future<bool> Function(Movie) isFavorite;

  const TrendingMovies({
    Key? key,
    required this.trending,
    required this.onFavoriteToggle,
    required this.isFavorite,
  }) : super(key: key);

  @override
  State<TrendingMovies> createState() => _TrendingMoviesState();
}

class _TrendingMoviesState extends State<TrendingMovies> {
  final Map<int, bool> _favoriteStatus = {};
  int? _currentlyProcessingId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: PageController(viewportFraction: 1),
        itemCount: widget.trending.length,
        itemBuilder: (context, index) {
          final movie = widget.trending[index];
          return FutureBuilder<bool>(
            future: widget.isFavorite(movie),
            builder: (context, snapshot) {
              if (snapshot.hasData && !_favoriteStatus.containsKey(movie.id)) {
                _favoriteStatus[movie.id] = snapshot.data!;
              }

              final isFav = _favoriteStatus[movie.id] ?? false;
              return _buildMovieCard(movie, isFav, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildMovieCard(Movie movie, bool isFav, BuildContext context) {
    final isProcessing = _currentlyProcessingId == movie.id;

    return Container(
      width: MediaQuery.of(context).size.width * 0.98,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Movie poster image
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(
                    movie: movie,
                    onFavoriteToggle: widget.onFavoriteToggle,
                    isFavorite: widget.isFavorite,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.posterUrl,
                width: MediaQuery.of(context).size.width,
                height: 420,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
          ),

          // Gradient overlay at bottom
          Positioned.fill(
            bottom: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Favorite button
          Positioned(
            bottom: 8,
            right: 13,
            child: IconButton(
              icon: isProcessing
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
                  : Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.white,
                size: 26,
              ),
              onPressed: isProcessing
                  ? null
                  : () => _handleFavoriteToggle(movie, isFav),
            ),
          ),

          // Movie title
          Positioned(
            bottom: 16,
            left: 16,
            right: 50,
            child: Container(
              child: Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleFavoriteToggle(Movie movie, bool currentStatus) async {
    setState(() {
      _currentlyProcessingId = movie.id;
      _favoriteStatus[movie.id] = !currentStatus;
    });

    try {
      await widget.onFavoriteToggle(movie);

      // Verify the actual status after toggle
      final actualStatus = await widget.isFavorite(movie);
      if (mounted) {
        setState(() {
          _favoriteStatus[movie.id] = actualStatus;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _currentlyProcessingId = null;
        });
      }
    }
  }
}