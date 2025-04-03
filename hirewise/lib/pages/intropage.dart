import 'package:flutter/material.dart';
import 'package:hirewise/components/category_circle.dart';
import 'package:hirewise/components/content_card.dart'; // Assuming this is GigCard
import 'package:hirewise/pages/Filterdgigbycategory.dart';
import 'package:hirewise/pages/Gig%20related%20pages/Giginsidepage.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer
import 'package:supabase_flutter/supabase_flutter.dart';

class Intropage extends StatefulWidget {
  const Intropage({super.key});

  @override
  State<Intropage> createState() => _IntropageState();
}

class _IntropageState extends State<Intropage> {
  late Future<List<Map<String, dynamic>>> _categoriesFuture;
  late Future<List<Map<String, dynamic>>> _workersFuture;
  bool _showNotifications = false;

  final SupabaseClient _supabase = Supabase.instance.client; // Cache client

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _categoriesFuture = _fetchCategories();
    _workersFuture = _fetchWorkers();
  }

  Future<String?> getCurrentUserId() async {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    if (user != null) {
      return user.id; // Returns the current user's ID
    } else {
      return null; // If no user is logged in
    }
  }

  // Add this method to your _IntropageState class
  Future<Map<String, dynamic>?> _fetchUserProfile() async {
    final userId = await getCurrentUserId();
    if (userId == null) return null;

    try {
      final response =
          await _supabase
              .from('profiles')
              .select('username, email') // Only select the fields you need
              .eq('id', userId)
              .single();
      return response;
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchCategories() async {
    try {
      final response = await _supabase
          .from('category')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      throw Exception('Failed to load categories. Please try again.');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchWorkers() async {
    try {
      final response = await _supabase
          .from('Giginfo')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching workers: $e');
      throw Exception('Failed to load workers. Please try again.');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF3F3F3), // Background color updated
        appBar: _buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          color: Color(0xFF222325), // Primary color for refresh
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildSectionTitle("Categories"),
                  _buildCategoriesSection(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Available Workers"),
                  _buildWorkersSection(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      elevation: 1,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _fetchUserProfile(),
          builder: (context, snapshot) {
            // While loading, show a placeholder
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF222325),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 17,
                        color: Colors.grey[200],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 100,
                        height: 13,
                        color: Colors.grey[200],
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Notification icon remains static during loading
                  _buildNotificationIcon(),
                ],
              );
            }

            // Default values if no data or error
            String username = "Guest User";

            if (snapshot.hasData && snapshot.data != null) {
              username = snapshot.data!['username'] ?? "Guest User";
            }

            return Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF222325),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222325),
                      ),
                    ),
                    Text(
                      "I'm a Client", // Keeping this static as per your original
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF222325).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _buildNotificationIcon(),
              ],
            );
          },
        ),
      ),
    );
  }

  // Extracted notification icon widget for reusability
  Widget _buildNotificationIcon() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            size: 28,
            color: Color(0xFF222325),
          ),
          onPressed: () {},
          tooltip: "Notifications",
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 12.0, right: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF222325), // Text color updated
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildCategoriesShimmer();
        } else if (snapshot.hasError) {
          return _buildErrorWidget(
            snapshot.error.toString(),
            () => _refreshData(),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyWidget(
            "No categories found.",
            Icons.category_outlined,
          );
        } else {
          final categories = snapshot.data!;
          return SizedBox(
            height: 110,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: CategoryCircle(
                    categoryName: category['category_name'] ?? 'Unnamed',
                    categoryImage: category['image_url'] ?? '',
                    categoryId: category['cat_id'].toString(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CategoryGigsPage(
                                categoryId: category['cat_id'].toString(),
                                categoryName:
                                    category['category_name'] ?? 'Unnamed',
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildCategoriesShimmer() {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 110,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[200]!,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[200]!,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWorkersSection(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      // Same logic for workers
      future: _workersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildWorkersShimmer();
        } else if (snapshot.hasError) {
          return _buildErrorWidget(
            snapshot.error.toString(),
            () => _refreshData(),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyWidget(
            "No workers available right now.",
            Icons.person_search_outlined,
          );
        } else {
          final workers = snapshot.data!;
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final worker = workers[index];
              final String gigId =
                  worker['id']?.toString() ?? 'unknown_id_$index';
              final String sellerName =
                  worker['sellername']?.toString() ?? 'Anonymous';
              final String gigTitle =
                  worker['Title']?.toString() ?? 'Untitled Gig';
              final String? thumbnailImage = worker['image_url']?.toString();
              final String price = worker['Price']?.toString() ?? 'N/A';
              final String profileImage =
                  worker['profile_image']?.toString() ??
                  'lib/images/avatar.jpg';
              final int reviews = worker['reviews'] as int? ?? 0;
              final bool isTopRated = worker['is_top_rated'] as bool? ?? false;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GigInsidePage(gigData: worker),
                    ),
                  );
                },
                child: GigCard(
                  sellerName: sellerName,
                  gigTitle: gigTitle,
                  thumbnailImage: thumbnailImage,
                  profileImage: profileImage,
                  reviews: reviews,
                  price: price,
                  isTopRated: isTopRated,
                  gigId: gigId,
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16.0),
          );
        }
      },
    );
  }

  Widget _buildWorkersShimmer() {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surface,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: 3,
        itemBuilder: (context, index) => _buildShimmerGigCardPlaceholder(),
        separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      ),
    );
  }

  Widget _buildShimmerGigCardPlaceholder() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 100,
                      height: 14,
                      color: colorScheme.surfaceContainerHighest,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 16,
                  color: colorScheme.surfaceContainerHighest,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 150,
                  height: 16,
                  color: colorScheme.surfaceContainerHighest,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 80,
                  height: 14,
                  color: colorScheme.surfaceContainerHighest,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String errorMsg, VoidCallback onRetry) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red.shade300,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              errorMsg,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade400, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF222325), // Button color updated
                foregroundColor: Colors.white, // Button text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(String message, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colorScheme.onSurface.withOpacity(0.4), size: 60),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
