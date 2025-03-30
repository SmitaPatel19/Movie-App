// import 'package:flutter/material.dart';
//
// class SortButton extends StatelessWidget {
//   final String currentSort;
//   final void Function(String) onSortChanged;
//
//   const SortButton({
//     super.key,
//     required this.currentSort,
//     required this.onSortChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.sort),
//       onPressed: () {
//         showModalBottomSheet(
//           context: context,
//           builder: (context) => Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Sort By',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const Divider(),
//                 _buildSortOption(context, 'title', 'Title'),
//                 _buildSortOption(context, 'released', 'Release Date'),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   ListTile _buildSortOption(BuildContext context, String value, String title) {
//     return ListTile(
//       leading: Icon(
//         value == 'title' ? Icons.title : Icons.date_range,
//       ),
//       title: Text(title),
//       trailing: currentSort == value
//           ? const Icon(Icons.check)
//           : null,
//       onTap: () {
//         onSortChanged(value);
//         Navigator.pop(context);
//       },
//     );
//   }
// }