import 'package:flutter/material.dart';
import '../model/movie_model.dart';
import '../screens/movie_description.dart';
import '../utils/text.dart';

class TopRatedMovies extends StatelessWidget {
  final List<Movie> toprated;
  final Function(Movie) onFavoriteToggle;
  final Future<bool> Function(Movie) isFavorite;

  const TopRatedMovies({
    Key? key,
    required this.toprated,
    required this.onFavoriteToggle,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const ModifiedText(
            text: 'Top Rated Movies',
            size: 24,
          ),
          SizedBox(height: 10),
          Container(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: toprated.length,
              itemBuilder: (context, index) {
                final movie = toprated[index];
                return FutureBuilder<bool>(
                  future: isFavorite(movie),
                  builder: (context, snapshot) {
                    final isFav = snapshot.data ?? false;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MovieDetailPage(movie: movie, onFavoriteToggle: onFavoriteToggle, isFavorite: isFavorite)
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Container(
                          width: 140,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(movie.posterUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: IconButton(
                                      icon: Icon(
                                        isFav ? Icons.favorite : Icons.favorite_border,
                                        color: isFav? Colors.red : Colors.white,
                                      ),
                                      onPressed: () => onFavoriteToggle(movie),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ModifiedText(
                                    text: movie.title,
                                    size: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}