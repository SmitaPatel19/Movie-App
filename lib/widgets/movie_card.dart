import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/movie_model.dart';
import '../screens/movie_description.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final Function(Movie)? onFavoriteToggle;
  final Future<bool> Function(Movie)? isFavorite;

  const MovieCard({
    Key? key,
    required this.movie,
    this.onFavoriteToggle,
    this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailPage(
                movie: movie,
                onFavoriteToggle: onFavoriteToggle ?? (_) {},
                isFavorite: isFavorite ?? (_) async => false,
              ),
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
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.broken_image),
                        ),
                      ),
                    )
                        : Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.movie),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: GoogleFonts.breeSerif(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
              if (onFavoriteToggle != null && isFavorite != null)
                FutureBuilder<bool>(
                  future: isFavorite!(movie),
                  builder: (context, snapshot) {
                    final isFav = snapshot.data ?? false;
                    return Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () => onFavoriteToggle!(movie),
                      ),
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