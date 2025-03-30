import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../model/movie_model.dart';
import '../utils/text.dart';
import 'package:share_plus/share_plus.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;
  final Function(Movie) onFavoriteToggle;
  final Future<bool> Function(Movie) isFavorite;

  const MovieDetailPage({
    Key? key,
    required this.movie,
    required this.onFavoriteToggle,
    required this.isFavorite,
  }) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late bool _isFavorite;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = false;
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      final isFav = await widget.isFavorite(widget.movie);
      if (mounted) {
        setState(() {
          _isFavorite = isFav;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFavorite = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Update UI immediately for better UX
      setState(() {
        _isFavorite = !_isFavorite;
      });

      // Call the parent's toggle function
      await widget.onFavoriteToggle(widget.movie);

      // Verify the actual status after toggle
      await _loadFavoriteStatus();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_left,
            color: Colors.white,
            size: 35,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () => _shareMovie(context),
          ),
          Stack(alignment: Alignment.center, children: [
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.white,
                size: 26,
              ),
              onPressed: _toggleFavorite,
            ),
            if (_isLoading)
              const Positioned(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ]),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: MovieHeaderImage(imageUrl: widget.movie.posterUrl),
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
    final text = 'Check out "${widget.movie.title}" on Movie App!\n\n'
        'Rating: ${widget.movie.voteAverage?.toStringAsFixed(1) ?? 'N/A'}\n'
        'Release Date: ${widget.movie.release_date ?? 'Unknown'}\n\n'
        'Download the app to see more details!';

    Share.share(
      text,
      subject: 'Movie Recommendation: ${widget.movie.title}',
    );
  }

  Widget _buildMovieHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModifiedText(
            text: widget.movie.title,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (widget.movie.voteAverage != null)
                _buildInfoChip(
                    'Rating: ${widget.movie.voteAverage?.toStringAsFixed(1)}'),
              if (widget.movie.release_date != null)
                _buildInfoChip('Released: ${widget.movie.release_date}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Chip(
      label: ModifiedText(
        text: text,
        size: 12,
        color: Colors.black,
      ),
      backgroundColor: Colors.white60,
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
                widget.movie.overview ?? 'No description available',

                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                      height: 1.5,
                    ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildGallerySection(BuildContext context) {
    final galleryImages = [
      widget.movie.posterUrl,
      widget.movie.backdropUrl ?? widget.movie.posterUrl
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Gallery'.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
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
                aspectRatio: 2 / 3,
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
              height: 350,
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
              color: Colors.white70,
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
