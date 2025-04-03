import 'package:flutter/material.dart';

class GigCardNew extends StatefulWidget {
  final String sellerId; // Add this
  final String sellerName;
  final String gigTitle;
  final String thumbnailImage;
  final String profileImage;
  final double rating;
  final int reviews;
  final String price;
  final bool isTopRated;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onSellerTap; // Add this
  final bool isFavorite;

  const GigCardNew({
    super.key,
    required this.sellerId, // Add this
    required this.sellerName,
    required this.gigTitle,
    required this.thumbnailImage,
    required this.profileImage,
    required this.rating,
    required this.reviews,
    required this.price,
    this.isTopRated = false,
    this.onTap,
    this.onFavoriteToggle,
    this.onSellerTap, // Add this
    this.isFavorite = false,
  });

  @override
  State<GigCardNew> createState() => _EnhancedGigCardNewState();
}

class _EnhancedGigCardNewState extends State<GigCardNew>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  // Color palette for contrast design
  final Color _primaryColor = const Color(0xFF222325); // Primary Color
  final Color _lightColor = const Color(0xFFF3F3F3); // Background Color

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          decoration: BoxDecoration(
            color: _lightColor, // Using background color
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color:
                    _isPressed
                        ? _primaryColor.withOpacity(0.1)
                        : _primaryColor.withOpacity(0.2),
                blurRadius: _isPressed ? 4 : 8,
                spreadRadius: _isPressed ? 0 : 1,
                offset: _isPressed ? const Offset(0, 1) : const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail with top-rated badge
                Stack(
                  children: [
                    Hero(
                      tag: 'gig-image-${widget.gigTitle}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.thumbnailImage,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 90,
                              height: 90,
                              color: _primaryColor.withOpacity(0.1),
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: _primaryColor.withOpacity(0.5),
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (widget.isTopRated)
                      Positioned(
                        top: 5,
                        left: 5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: _lightColor, size: 10),
                              const SizedBox(width: 2),
                              Text(
                                'TOP',
                                style: TextStyle(
                                  color: _lightColor,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Gig details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gig title
                      Text(
                        widget.gigTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _primaryColor,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.rating}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                          Text(
                            " (${widget.reviews})",
                            style: TextStyle(
                              fontSize: 12,
                              color: _primaryColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Seller info
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _primaryColor.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(widget.profileImage),
                              radius: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.sellerName,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: _primaryColor.withOpacity(0.8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Price and favorite
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Favorite button
                    GestureDetector(
                      onTap: widget.onFavoriteToggle,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              widget.isFavorite
                                  ? _primaryColor.withOpacity(0.1)
                                  : _primaryColor.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              widget.isFavorite
                                  ? _primaryColor
                                  : _primaryColor.withOpacity(0.5),
                          size: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Price
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "\$${widget.price}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
