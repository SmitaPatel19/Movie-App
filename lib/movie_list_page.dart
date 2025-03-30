// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'movie_description_page.dart';
// import 'movie_model.dart';
//
// class MovieListPage extends StatefulWidget {
//   @override
//   _MovieListPageState createState() => _MovieListPageState();
// }
//
// class _MovieListPageState extends State<MovieListPage> {
//
//   final List<Movie> allMovies = Movie.getMovies();
//   List<Movie> displayedMovies = [];
//   List<Movie> favoriteMovies = [];
//   final TextEditingController _searchController = TextEditingController();
//   String _sortBy = 'title';
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     displayedMovies = List.from(allMovies);
//     _loadFavorites();
//   }
//
//   Future<void> _loadFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     final favoriteIds = prefs.getStringList('favorites') ?? [];
//
//     setState(() {
//       favoriteMovies = allMovies.where((movie) =>
//           favoriteIds.contains(movie.title)).toList();
//     });
//   }
//
//   Future<void> _toggleFavorite(Movie movie) async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       if (favoriteMovies.contains(movie)) {
//         favoriteMovies.remove(movie);
//       } else {
//         favoriteMovies.add(movie);
//       }
//     });
//     await prefs.setStringList('favorites',
//         favoriteMovies.map((m) => m.title).toList());
//   }
//
//   void _searchMovies(String query) {
//     setState(() {
//       displayedMovies = allMovies.where((movie) {
//         return movie.title.toLowerCase().contains(query.toLowerCase()) ||
//             movie.genres.toLowerCase().contains(query.toLowerCase());
//       }).toList();
//       _sortMovies(_sortBy);
//     });
//   }
//
//   void _sortMovies(String criteria) {
//     setState(() {
//       _sortBy = criteria;
//       displayedMovies.sort((a, b) {
//         switch (criteria) {
//           case 'title': return a.title.compareTo(b.title);
//           case 'episodes': return int.parse(a.episodes).compareTo(int.parse(b.episodes));
//           case 'released': return a.released.compareTo(b.released);
//           default: return 0;
//         }
//       });
//     });
//   }
//
//   Future<void> _refreshMovies() async {
//     setState(() => _isLoading = true);
//     await Future.delayed(Duration(milliseconds: 800));
//     setState(() {
//       displayedMovies = List.from(allMovies);
//       _sortMovies(_sortBy);
//       _isLoading = false;
//     });
//   }
//
//   Widget _buildSearchBar() {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
//       child: TextField(
//         controller: _searchController,
//         decoration: InputDecoration(
//           hintText: 'Search movies...',
//           prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[600]),
//           filled: true,
//           fillColor: Colors.grey[100],
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
//           suffixIcon: _searchController.text.isNotEmpty
//               ? IconButton(
//             icon: Icon(Icons.clear_rounded, color: Colors.grey[600]),
//             onPressed: () {
//               _searchController.clear();
//               _searchMovies('');
//             },
//           )
//               : null,
//         ),
//         onChanged: _searchMovies,
//       ),
//     );
//   }
//
//   Widget _buildSortButton() {
//     return IconButton(
//       icon: Icon(Icons.sort_rounded, color: Colors.deepPurple),
//       onPressed: () {
//         showModalBottomSheet(
//           context: context,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           builder: (BuildContext context) => Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('Sort By', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 Divider(),
//                 ListTile(
//                   leading: Icon(Icons.title_rounded),
//                   title: Text('Title'),
//                   trailing: _sortBy == 'title' ? Icon(Icons.check_rounded) : null,
//                   onTap: () {
//                     _sortMovies('title');
//                     Navigator.pop(context);
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.list_alt_rounded),
//                   title: Text('Episodes'),
//                   trailing: _sortBy == 'episodes' ? Icon(Icons.check_rounded) : null,
//                   onTap: () {
//                     _sortMovies('episodes');
//                     Navigator.pop(context);
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.date_range_rounded),
//                   title: Text('Release Date'),
//                   trailing: _sortBy == 'released' ? Icon(Icons.check_rounded) : null,
//                   onTap: () {
//                     _sortMovies('released');
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//   Widget _buildMovieCard(Movie movie, BuildContext context, {bool isFavoritePage = false}) {
//     final isFavorite = favoriteMovies.contains(movie);
//
//     return AnimationConfiguration.staggeredList(
//       position: isFavoritePage
//           ? favoriteMovies.indexOf(movie)
//           : displayedMovies.indexOf(movie),
//       duration: Duration(milliseconds: 500),
//       child: SlideAnimation(
//         verticalOffset: 50,
//         child: FadeInAnimation(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Card(
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16)),
//               clipBehavior: Clip.antiAlias,
//               child: InkWell(
//                 onTap: () => Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     transitionDuration: Duration(milliseconds: 500),
//                     pageBuilder: (context, animation, secondaryAnimation) =>
//                         MovieDescriptionPage(movie: movie),
//                     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                       return FadeTransition(
//                         opacity: animation,
//                         child: child,
//                       );
//                     },
//                   ),
//                 ),
//                 child: Stack(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         AspectRatio(
//                           aspectRatio: 16/9,
//                           child: movie.image.isNotEmpty
//                               ? Image.asset(
//                             movie.image[0],
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, __, ___) => Center(
//                               child: Icon(Icons.movie_rounded, size: 50, color: Colors.grey[300]),
//                             ),
//                           )
//                               : Container(
//                             color: Colors.grey[100],
//                             child: Center(
//                               child: Icon(Icons.movie_rounded, size: 50, color: Colors.grey[300]),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 movie.title,
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                   height: 1.2,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                     decoration: BoxDecoration(
//                                       color: Colors.amber.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Icon(Icons.star_rounded, size: 16, color: Colors.amber),
//                                         SizedBox(width: 4),
//                                         Text(
//                                           '${movie.rating ?? 'N/A'}',
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.amber[800],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(width: 8),
//                                   Container(
//                                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                     decoration: BoxDecoration(
//                                       color: Colors.blue.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: Text(
//                                       movie.episodes + ' Eps',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.blue[800],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 movie.genres,
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.grey[600],
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Positioned(
//                       top: 12,
//                       right: 12,
//                       child: GestureDetector(
//                         onTap: () => _toggleFavorite(movie),
//                         child: AnimatedContainer(
//                           duration: Duration(milliseconds: 300),
//                           padding: EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: isFavorite
//                                 ? Colors.red.withOpacity(0.9)
//                                 : Colors.white.withOpacity(0.9),
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 4,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: AnimatedSwitcher(
//                             duration: Duration(milliseconds: 300),
//                             child: Icon(
//                               isFavorite
//                                   ? Icons.favorite_rounded
//                                   : Icons.favorite_border_rounded,
//                               key: ValueKey<bool>(isFavorite),
//                               color: isFavorite ? Colors.white : Colors.grey[600],
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFavoritesPage() {
//     return RefreshIndicator(
//       onRefresh: _loadFavorites,
//       color: Colors.deepPurple,
//       backgroundColor: Colors.white,
//       child: favoriteMovies.isEmpty
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.favorite_border_rounded, size: 60, color: Colors.grey[400]),
//             SizedBox(height: 16),
//             Text(
//               'No favorites yet',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Tap the heart icon to add favorites',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       )
//           : AnimationLimiter(
//         child: ListView.builder(
//           padding: EdgeInsets.symmetric(vertical: 8),
//           itemCount: favoriteMovies.length,
//           itemBuilder: (context, index) =>
//               _buildMovieCard(favoriteMovies[index], context, isFavoritePage: true),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAllMoviesPage() {
//     return RefreshIndicator(
//       onRefresh: _refreshMovies,
//       color: Colors.deepPurple,
//       backgroundColor: Colors.white,
//       child: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(child: _buildSearchBar()),
//           _isLoading
//               ? SliverFillRemaining(
//             child: Center(child: CircularProgressIndicator()),
//           )
//               : displayedMovies.isEmpty
//               ? SliverFillRemaining(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.search_off_rounded, size: 60, color: Colors.grey[400]),
//                   SizedBox(height: 16),
//                   Text(
//                     'No movies found',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//               : SliverList(
//             delegate: SliverChildBuilderDelegate(
//                   (context, index) => _buildMovieCard(displayedMovies[index], context),
//               childCount: displayedMovies.length,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           title: Text('Movies', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.deepPurple)),
//           centerTitle: true,
//           elevation: 0,
//           backgroundColor: Colors.white,
//           actions: [_buildSortButton()],
//           bottom: TabBar(
//             indicatorColor: Colors.deepPurple,
//             labelColor: Colors.deepPurple,
//             unselectedLabelColor: Colors.grey[600],
//             labelStyle: TextStyle(fontWeight: FontWeight.w600),
//             tabs: [
//               Tab(icon: Icon(Icons.movie_rounded), text: 'All Movies'),
//               Tab(icon: Icon(Icons.favorite_rounded), text: 'Favorites'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildAllMoviesPage(),
//             _buildFavoritesPage(),
//           ],
//         ),
//       ),
//     );
//   }
// }