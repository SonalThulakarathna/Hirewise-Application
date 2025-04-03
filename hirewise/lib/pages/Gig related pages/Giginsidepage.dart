import 'package:flutter/material.dart';
import 'package:hirewise/pages/clientrequest.dart';
import 'package:hirewise/pages/sellerprofile.dart';

class GigInsidePage extends StatefulWidget {
  final Map<String, dynamic> gigData;

  const GigInsidePage({super.key, required this.gigData});

  @override
  State<GigInsidePage> createState() => _GigInsidePageState();
}

class _GigInsidePageState extends State<GigInsidePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> _gigDetails;

  final Color _primaryColor = const Color(0xFF222325); // Primary Color
  final Color _lightColor = const Color(0xFFF3F3F3); // Light Background Color

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _gigDetails = widget.gigData;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightColor,
      body:
          _gigDetails.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                slivers: [
                  _buildSliverAppBar(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSellerInfo(),
                        _buildGigTitle(),
                        _buildTabBar(),
                        _buildTabContent(),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
      bottomSheet: _buildBottomActionBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: _primaryColor,
      title: const Text(
        'Gig Details',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.favorite_border, color: _primaryColor),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.share_outlined, color: _primaryColor),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'gig-image-${_gigDetails['id'] ?? ''}',
              child: Container(
                decoration: BoxDecoration(color: Colors.grey.shade200),
                child: Image.network(
                  _gigDetails['image_url'] ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                              color: _primaryColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Image not available",
                              style: TextStyle(
                                color: _primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerInfo() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => SellerProfilePage(
                  sellerId: _gigDetails['user_id'].toString(),
                ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  _gigDetails['profileimage'] ?? 'lib/images/avatar.jpg',
                ),
                backgroundColor: Colors.grey.shade200,
                onBackgroundImageError: (exception, stackTrace) {},
              ),
            ),

            // ... rest of the seller info row
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _gigDetails['sellername'] ?? 'Unknown',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    (_gigDetails['rating'] ?? '5.0').toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' (${_gigDetails['reviews'] ?? '0'})',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGigTitle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _gigDetails['Title'] ?? 'No title available.',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _primaryColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.attach_money, color: _primaryColor, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${_gigDetails['Price'] ?? '0'}/hour',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: _primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: _primaryColor,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'Description'),
          Tab(text: 'Services'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      height: 300,
      color: Colors.white,
      child: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About This Gig',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  _gigDetails['Description'] ?? 'No description available.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Services',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildServiceItem(
                  _gigDetails['servicedescript'] ??
                      'UI/UX Design for Mobile Apps',
                  'Complete design with wireframes, mockups, and prototypes',
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.star, color: Colors.green, size: 14),
                          SizedBox(width: 2),
                          Text(
                            '5.0',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${_gigDetails['reviews'] ?? '0'} reviews)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildReviewItem(
                  'John Doe',
                  'https://via.placeholder.com/150',
                  5.0,
                  'Great work! The design exceeded my expectations. Very professional and responsive.',
                  '2 days ago',
                ),
                _buildReviewItem(
                  'Sarah Smith',
                  'https://via.placeholder.com/150',
                  5.0,
                  'Amazing attention to detail. Will definitely work with again!',
                  '1 week ago',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: _primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
    String name,
    String avatar,
    double rating,
    String comment,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(avatar),
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(comment, style: const TextStyle(fontSize: 14, height: 1.5)),
          const SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.message_outlined),
              label: const Text('Contact Seller'),
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: _primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.request_page, color: Colors.white),
              label: const Text(
                'Request Seller',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ClientRequestPage(
                          gigId: _gigDetails['id'].toString(),
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: _primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
