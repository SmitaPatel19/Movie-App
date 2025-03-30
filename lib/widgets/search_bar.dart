// import 'package:flutter/material.dart';
//
// class MySearchBar extends StatelessWidget {
//   final void Function(String) onSearch;
//   final TextEditingController _controller = TextEditingController();
//
//   MySearchBar({super.key, required this.onSearch});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//       child: TextField(
//         controller: _controller,
//         decoration: InputDecoration(
//           hintText: 'Search movies...',
//           prefixIcon: const Icon(Icons.search),
//           suffixIcon: _controller.text.isNotEmpty
//               ? IconButton(
//             icon: const Icon(Icons.clear),
//             onPressed: () {
//               _controller.clear();
//               onSearch('');
//             },
//           )
//               : null,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         onChanged: onSearch,
//       ),
//     );
//   }
// }