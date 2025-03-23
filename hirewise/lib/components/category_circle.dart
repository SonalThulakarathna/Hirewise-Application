import 'package:flutter/material.dart';

class CategoryCircle extends StatelessWidget {
  final String categoryName;
  final String categoryImage; // New parameter for the category image

  const CategoryCircle({
    super.key,
    required this.categoryName,
    required this.categoryImage, // Required category image
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular image container
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              categoryImage,
              fit: BoxFit.cover, // Cover the circular space
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.category,
                  size: 40,
                  color: Colors.white,
                );
              },
            ),
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
