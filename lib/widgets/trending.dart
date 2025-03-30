import 'package:flutter/material.dart';
import '../model/movie_model.dart';
import '../screens/movie_description.dart';
import '../utils/text.dart';

class TrendingMovies extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const ModifiedText(
            text: 'Trending Movies',
            size: 26,
            color: Colors.deepPurple,
          ),
          SizedBox(height: 10),
          Container(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: trending.length,
              itemBuilder: (context, index) {
                final movie = trending[index];
                return FutureBuilder<bool>(
                  future: isFavorite(movie),
                  builder: (context, snapshot) {
                    final isFav = snapshot.data ?? false;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(movie: movie)
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
                                        color: Colors.red,
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