import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../model/movie_model.dart';
import '../screens/movie_description.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final Function()? onFavoriteToggle;
  final bool isFavorite;

  const MovieCard({
    super.key,
    required this.movie,
    this.onFavoriteToggle,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailPage(movie: movie),
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: movie.poster_path != null
                        ? Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                    )
                        : Container(color: Colors.grey[200]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                '⭐ ${movie.voteAverage?.toStringAsFixed(1) ?? 'N/A'}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (onFavoriteToggle != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}