// In category_circle.dart
import 'package:flutter/material.dart';

class CategoryCircle extends StatelessWidget {
  final String categoryName;

  const CategoryCircle({Key? key, required this.categoryName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon container
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        // Text with overflow handling
        SizedBox(
          width: 80, // Fixed width
          child: Text(
            categoryName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 2, // Allow up to 2 lines
            overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
          ),
        ),
      ],
    );
  }
}
