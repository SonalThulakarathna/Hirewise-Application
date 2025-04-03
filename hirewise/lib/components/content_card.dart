import 'package:flutter/material.dart';

/// An enhanced card widget that displays gig information with a modern design
/// This widget handles both local and network images with proper error handling
class GigCard extends StatelessWidget {
  // Required fields for basic gig information
  final String sellerName;
  final String gigTitle;
  final String?
  thumbnailImage; // Made nullable to handle cases where no image is available
  final String profileImage;
  final String price;
  final String gigId;

  // Optional fields for additional information
  final double? rating; // Made nullable since it's not in the database
  final int? reviews; // Made nullable since it's not in the database
  final bool? isTopRated; // Made nullable since it's not in the database
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;

  const GigCard({
    super.key,
    required this.sellerName,
    required this.gigTitle,
    this.thumbnailImage, // Made optional to handle null cases
    required this.profileImage,
    required this.price,
    required this.gigId,
    this.rating, // Made optional
    this.reviews, // Made optional
    this.isTopRated, // Made optional
    this.onTap,
    this.onFavoriteToggle,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDark ? Colors.grey[900] : Color(0xFFF3F3F3); // Background color
    final textColor = isDark ? Colors.white : Color(0xFF222325); // Text color
    final shadowColor = isDark ? Colors.black : Colors.black.withOpacity(0.05);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Image Section with Enhanced Error Handling
            _buildThumbnailSection(isDark),

            // Seller Information Section
            _buildSellerSection(isDark),

            // Gig Title Section
            _buildTitleSection(isDark),

            // Rating and Reviews Section
            _buildRatingSection(isDark),

            // Price Section with updated branding color
            _buildPriceSection(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailSection(bool isDark) {
    return Stack(
      children: [
        // Image container with ClipRRect for rounded corners
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child:
                thumbnailImage != null && thumbnailImage!.isNotEmpty
                    ? Image.network(
                      thumbnailImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        // Enhanced error placeholder
                        return Container(
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 32,
                                  color:
                                      isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[400],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Image not available",
                                  style: TextStyle(
                                    color:
                                        isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        // Enhanced loading placeholder
                        return Container(
                          color: isDark ? Colors.grey[800] : Colors.grey[100],
                          child: Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                              strokeWidth: 2,
                              color: Colors.blue[700],
                            ),
                          ),
                        );
                      },
                    )
                    : Container(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 32,
                          color: isDark ? Colors.grey[400] : Colors.grey[400],
                        ),
                      ),
                    ),
          ),
        ),

        // Favorite button with animation
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color:
                    isFavorite
                        ? Colors.red
                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                size: 18,
              ),
            ),
          ),
        ),

        // Top Rated badge
        if (isTopRated == true)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 12),
                  const SizedBox(width: 4),
                  const Text(
                    "Top Rated",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Preview button with gradient background
        Positioned(
          left: 12,
          bottom: 12,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Preview",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSellerSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          // Enhanced seller profile picture with border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              backgroundImage: AssetImage(profileImage),
              radius: 16,
            ),
          ),
          const SizedBox(width: 8),

          // Seller name with verification icon
          Row(
            children: [
              Text(
                sellerName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark ? Colors.white : Color(0xFF222325),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.verified, size: 14, color: Colors.blue[700]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        gigTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          height: 1.3,
          color: isDark ? Colors.white : Color(0xFF222325),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildRatingSection(bool isDark) {
    if (rating == null && reviews == null) {
      return const SizedBox(height: 4);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            rating?.toStringAsFixed(1) ?? '0.0',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? Colors.white : Color(0xFF222325),
            ),
          ),
          Text(
            " (${reviews ?? 0}+)",
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Starting at",
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "\$$price",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(
                    0xFF222325,
                  ), // Updated price color to match branding
                ),
              ),
            ],
          ),

          // Quick action button with updated branding color
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(
                0xFF222325,
              ), // Updated button color to match branding
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "View Details",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white, // Text color updated to white for contrast
              ),
            ),
          ),
        ],
      ),
    );
  }
}
