import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../model/movie_model.dart';


class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () => _shareMovie(context),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: Colors.white),
            onPressed: () => _toggleFavorite(context),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: MovieHeaderImage(imageUrl: movie.posterUrl),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 24),
              _buildMovieHeader(context),
              const SizedBox(height: 16),
              _buildMovieDetails(context),
              const SizedBox(height: 24),
              _buildGallerySection(context),
              const SizedBox(height: 24),
            ]),
          ),
        ],
      ),
    );
  }

  void _shareMovie(BuildContext context) {
    // Implement share functionality
    final text = 'Check out ${movie.title} on Movie App!';
    // Share.share(text); // Uncomment if using the share package
  }

  void _toggleFavorite(BuildContext context) {
    // Implement favorite toggle functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${movie.title} added to favorites')),
    );
  }

  Widget _buildMovieHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[800],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (movie.voteAverage != null)
                _buildInfoChip('Rating: ${movie.voteAverage?.toStringAsFixed(1)}'),
              if (movie.release_date != null)
                _buildInfoChip('Released: ${movie.release_date}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Chip(
      label: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.deepPurple[50],
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildMovieDetails(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 500),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 50,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                movie.overview ?? 'No description available',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 16),
            ..._buildInfoRows(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInfoRows() {
    return [
      // if (movie.genres != null && movie.genres!.isNotEmpty)
      //   _buildInfoRow('Genres', movie.genres!.join(', ')),
      // if (movie.originalLanguage != null)
      //   _buildInfoRow('Language', movie.originalLanguage!.toUpperCase()),
      // if (movie.runtime != null)
      //   _buildInfoRow('Runtime', '${movie.runtime} minutes'),
    ];
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection(BuildContext context) {
    // For now using the same image, but you can replace with actual gallery images
    final galleryImages = [movie.posterUrl, movie.backdropUrl ?? movie.posterUrl];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Gallery'.toUpperCase(),
            style: TextStyle(
              color: Colors.deepPurple[800],
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: galleryImages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 2/3,
                child: Image.network(
                  galleryImages[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MovieHeaderImage extends StatelessWidget {
  final String? imageUrl;

  const MovieHeaderImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: imageUrl != null
                  ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
              )
                  : _buildPlaceholder(),
            ),
            const Icon(
              Icons.play_circle_outline,
              size: 100,
              color: Colors.white54,
            ),
          ],
        ),
        Container(
          height: 30,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Theme.of(context).scaffoldBackgroundColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.movie_rounded, size: 60, color: Colors.grey),
      ),
    );
  }
}