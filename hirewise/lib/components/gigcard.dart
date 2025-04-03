import 'package:flutter/material.dart';

/// A premium, modern card widget that displays gig information with a professional design
/// This widget handles both local and network images with proper error handling
class GigCardnew extends StatelessWidget {
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

  const GigCardnew({
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
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF222325);
    final secondaryTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final accentColor = const Color(0xFF1DBF73); // Professional green accent
    final shadowColor =
        isDark ? Colors.black54 : Colors.black.withOpacity(0.08);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Image Section with Enhanced Error Handling
            _buildThumbnailSection(isDark, accentColor),

            // Seller Information Section
            _buildSellerSection(isDark, textColor, accentColor),

            // Gig Title Section
            _buildTitleSection(isDark, textColor),

            // Rating and Reviews Section
            _buildRatingSection(isDark, textColor, secondaryTextColor),

            // Price Section with updated branding color
            _buildPriceSection(
              isDark,
              textColor,
              secondaryTextColor,
              accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailSection(bool isDark, Color accentColor) {
    return Stack(
      children: [
        // Image container with ClipRRect for rounded corners
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child:
                thumbnailImage != null && thumbnailImage!.isNotEmpty
                    ? Image.network(
                      thumbnailImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        // Enhanced error placeholder with gradient background
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors:
                                  isDark
                                      ? [Colors.grey[900]!, Colors.grey[800]!]
                                      : [Colors.grey[200]!, Colors.grey[100]!],
                            ),
                          ),
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
                                          : Colors.grey[500],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Image not available",
                                  style: TextStyle(
                                    color:
                                        isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        // Enhanced loading placeholder with shimmer effect
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors:
                                  isDark
                                      ? [Colors.grey[900]!, Colors.grey[800]!]
                                      : [Colors.grey[200]!, Colors.grey[100]!],
                            ),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                              strokeWidth: 2,
                              color: accentColor,
                            ),
                          ),
                        );
                      },
                    )
                    : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors:
                              isDark
                                  ? [Colors.grey[900]!, Colors.grey[800]!]
                                  : [Colors.grey[200]!, Colors.grey[100]!],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 32,
                          color: isDark ? Colors.grey[400] : Colors.grey[500],
                        ),
                      ),
                    ),
          ),
        ),

        // Favorite button with improved animation and shadow
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? Colors.grey[800]!.withOpacity(0.8)
                        : Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
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

        // Top Rated badge with improved design
        if (isTopRated == true)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.star, color: Colors.white, size: 12),
                  SizedBox(width: 4),
                  Text(
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

        // Preview button with improved gradient and shadow
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
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
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

  Widget _buildSellerSection(bool isDark, Color textColor, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          // Enhanced seller profile picture with improved border
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [accentColor, accentColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: CircleAvatar(
              backgroundImage: AssetImage(profileImage),
              radius: 14,
            ),
          ),
          const SizedBox(width: 10),

          // Seller name with verification icon
          Row(
            children: [
              Text(
                sellerName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.verified, size: 14, color: accentColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Text(
        gigTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          height: 1.3,
          color: textColor,
          letterSpacing: 0.1,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildRatingSection(
    bool isDark,
    Color textColor,
    Color? secondaryTextColor,
  ) {
    if (rating == null && reviews == null) {
      return const SizedBox(height: 4);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          // Star icon with improved design
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.star, color: Colors.amber, size: 14),
          ),
          const SizedBox(width: 6),
          Text(
            rating?.toStringAsFixed(1) ?? '0.0',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: textColor,
            ),
          ),
          Text(
            " (${reviews ?? 0}+)",
            style: TextStyle(fontSize: 13, color: secondaryTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(
    bool isDark,
    Color textColor,
    Color? secondaryTextColor,
    Color accentColor,
  ) {
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
                  color: secondaryTextColor,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    "\$$price",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: accentColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Quick action button with improved design
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              "View Details",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
