// import 'package:flutter/material.dart';
//
// import 'package:movie_app/widgets/movie_card.dart';
//
// import '../model/movie_model.dart';
//
// class MovieList extends StatelessWidget {
//   final List<Movie> movies;
//   final bool Function(Movie) isFavorite;
//   final void Function(Movie) onFavoriteToggle;
//   final void Function(Movie) onTap;
//
//   const MovieList({
//     super.key,
//     required this.movies,
//     required this.isFavorite,
//     required this.onFavoriteToggle,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       itemCount: movies.length,
//       itemBuilder: (context, index) {
//         final movie = movies[index];
//         return MovieCard(
//           movie: movie,
//         );
//       },
//     );
//   }
// }