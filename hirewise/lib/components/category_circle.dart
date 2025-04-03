import 'package:flutter/material.dart';

class CategoryCircle extends StatelessWidget {
  final String categoryName;
  final String categoryImage;
  final String categoryId;
  final VoidCallback? onTap;

  const CategoryCircle({
    super.key,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryId,
    this.onTap,
  });

  // Helper method to get appropriate icon for each category
  IconData _getCategoryIcon() {
    switch (categoryName.toLowerCase()) {
      case 'plumbing':
        return Icons.plumbing;
      case 'mechanical':
        return Icons.build;
      case 'painting':
        return Icons.brush;
      case 'construction':
        return Icons.construction;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'driving':
        return Icons.directions_car;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular image container
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child:
                  categoryImage.isNotEmpty
                      ? Image.network(
                        categoryImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              _getCategoryIcon(),
                              size: 40,
                              color: Colors.white,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                      )
                      : Center(
                        child: Icon(
                          _getCategoryIcon(),
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Text(
              categoryName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
