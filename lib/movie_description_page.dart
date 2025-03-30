// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'movie_model.dart';
//
// class MovieDescriptionPage extends StatelessWidget {
//   final Movie movie;
//
//   const MovieDescriptionPage({Key? key, required this.movie}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.share_rounded, color: Colors.white),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(Icons.favorite_border_rounded, color: Colors.white),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(
//             child: MovieImageWidget(
//               image: movie.image.length > 1 ? movie.image[1] : movie.image[0],
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate([
//               SizedBox(height: 24),
//               _buildMovieHeader(context),
//               SizedBox(height: 16),
//               _buildMovieDetails(context),
//               SizedBox(height: 24),
//               _buildGallerySection(context),
//               SizedBox(height: 24),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMovieHeader(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             movie.title,
//             style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: Colors.deepPurple[800],
//             ),
//           ),
//           SizedBox(height: 8),
//           Wrap(
//             spacing: 8,
//             runSpacing: 4,
//             children: [
//               _buildInfoChip(movie.language),
//               _buildInfoChip(movie.genres),
//               _buildInfoChip(movie.runtime),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoChip(String text) {
//     return Chip(
//       label: Text(
//         text,
//         style: TextStyle(fontSize: 12),
//       ),
//       backgroundColor: Colors.deepPurple[50],
//       visualDensity: VisualDensity.compact,
//       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//     );
//   }
//
//   Widget _buildMovieDetails(BuildContext context) {
//     return AnimationLimiter(
//       child: Column(
//         children: AnimationConfiguration.toStaggeredList(
//           duration: Duration(milliseconds: 500),
//           childAnimationBuilder: (widget) => SlideAnimation(
//             horizontalOffset: 50,
//             child: FadeInAnimation(child: widget),
//           ),
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24),
//               child: Text(
//                 movie.plot,
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                   color: Colors.grey[800],
//                   height: 1.5,
//                 ),
//               ),
//             ),
//             SizedBox(height: 24),
//             Divider(height: 1, thickness: 1),
//             SizedBox(height: 16),
//             ..._buildInfoRows(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _buildInfoRows() {
//     return [
//       _buildInfoRow('Genres', movie.genres),
//       _buildInfoRow('Language', movie.language),
//       _buildInfoRow('Episodes', movie.episodes),
//       _buildInfoRow('Runtime', movie.runtime),
//       _buildInfoRow('Released on', movie.released),
//       _buildInfoRow('Certificate', movie.certificate),
//       _buildInfoRow('Also known as', movie.otherName),
//       _buildInfoRow('Country', movie.country),
//     ];
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: Colors.grey[800],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGallerySection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24),
//           child: Text(
//             'More Drama Posters'.toUpperCase(),
//             style: TextStyle(
//               color: Colors.deepPurple[800],
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               letterSpacing: 1.2,
//             ),
//           ),
//         ),
//         SizedBox(height: 16),
//         Container(
//           height: 200,
//           child: ListView.separated(
//             padding: EdgeInsets.symmetric(horizontal: 24),
//             scrollDirection: Axis.horizontal,
//             itemCount: movie.image.length,
//             separatorBuilder: (_, __) => SizedBox(width: 16),
//             itemBuilder: (context, index) => ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: AspectRatio(
//                 aspectRatio: 2/3,
//                 child: Image.asset(
//                   movie.image[index],
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // Keep the original MovieImageWidget exactly as is
// class MovieImageWidget extends StatelessWidget {
//   final String image;
//
//   const MovieImageWidget({Key? key, required this.image}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.bottomCenter,
//       children: [
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: 300,
//               child: Image.asset(image, fit: BoxFit.cover),
//             ),
//             Icon(
//               Icons.play_circle_outline,
//               size: 100,
//               color: Colors.purple.shade50,
//             ),
//           ],
//         ),
//         Container(
//           height: 30,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0x00f5f5f5),
//                 Colors.purple.shade50,
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }