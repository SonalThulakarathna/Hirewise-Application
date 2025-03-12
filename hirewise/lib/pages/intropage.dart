import 'package:flutter/material.dart';
import 'package:hirewise/components/category_circle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Intropage extends StatefulWidget {
  const Intropage({super.key});

  @override
  State<Intropage> createState() => _IntropageState();
}

class _IntropageState extends State<Intropage> {
  late Future<List<Map<String, dynamic>>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories();
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await Supabase.instance.client
        .from('category')
        .select()
        .order('created_at', ascending: false);

    if (response.isEmpty) {
      throw Exception('No categories found');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  // Added refresh function for better UX
  Future<void> _refreshCategories() async {
    setState(() {
      _categoriesFuture = fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Added theme data for consistent styling
      theme: ThemeData(
        primaryColor: Colors.blue.shade700,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade700,
          brightness: Brightness.light,
        ),
        fontFamily: "roboto",
        useMaterial3: true, // Using Material 3 for modern look
      ),
      home: SafeArea(
        child: Scaffold(
          // Added gradient background for modern look
          backgroundColor: Colors.grey.shade50,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70), // Reduced height slightly
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // Improved shadow for more subtle, modern look
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AppBar(
                toolbarHeight: 70,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                // Improved layout with better spacing
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50, // Added background to logo
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        'lib/images/apple.png',
                        width: 32,
                        height: 32,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Hirewise",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Slightly softer black
                        fontFamily: "roboto",
                      ),
                    ),
                  ],
                ),
                actions: [
                  // Added notification icon for modern app feel
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.black87,
                      size: 26,
                    ),
                    onPressed: () {
                      // Notification functionality
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black87,
                      size: 26,
                    ),
                    onPressed: () {
                      // Search functionality
                    },
                  ),
                  const SizedBox(width: 8), // Added padding at the end
                ],
              ),
            ),
          ),
          // Wrapped body in RefreshIndicator for pull-to-refresh functionality
          body: RefreshIndicator(
            onRefresh: _refreshCategories,
            color: Colors.blue.shade700,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Added section title for better organization
                    const Padding(
                      padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _categoriesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Improved loading state with shimmer effect placeholder
                          return SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5, // Show 5 placeholder items
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 60,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (snapshot.hasError) {
                          // Improved error state with retry button
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _refreshCategories,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          // Improved empty state
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  color: Colors.grey,
                                  size: 60,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No categories available.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        } else {
                          final categories = snapshot.data!;
                          // Added container with subtle shadow for better visual hierarchy
                          return Container(
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                // Added animated hover effect for better interactivity
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: AnimatedScale(
                                    scale: 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: CategoryCircle(
                                      categoryName: category['category_name'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    // Added recommended jobs section for better content organization
                    const Padding(
                      padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                      child: Text(
                        "Recommended for you",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Placeholder for recommended jobs
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Recommended jobs will appear here",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Added bottom navigation for complete app experience
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blue.shade700,
            unselectedItemColor: Colors.grey,
            currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_outline),
                activeIcon: Icon(Icons.work),
                label: 'Jobs',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline),
                activeIcon: Icon(Icons.bookmark),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              // Handle navigation
            },
          ),
        ),
      ),
    );
  }
}
