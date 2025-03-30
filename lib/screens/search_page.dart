import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../model/movie_model.dart';
import '../widgets/movie_card.dart';

class SearchPage extends StatefulWidget {
  final List<Movie> movies;

  const SearchPage({super.key, required this.movies});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<Movie> filteredMovies;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMovies = List.from(widget.movies);
  }

  void _searchMovies(String query) {
    setState(() {
      filteredMovies = widget.movies.where((movie) {
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _searchMovies,
            ),
          ),
          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: filteredMovies.length,
                itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: MovieCard(movie: filteredMovies[index]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}