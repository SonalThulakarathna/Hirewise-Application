import 'package:flutter/material.dart';
import 'package:hirewise/components/category_circle.dart';
import 'package:hirewise/components/content_card.dart';
import 'package:hirewise/pages/Gig%20related%20pages/Giginsidepage.dart'; // Import GigInsidePage
import 'package:supabase_flutter/supabase_flutter.dart';

class Intropage extends StatefulWidget {
  const Intropage({super.key});

  @override
  State<Intropage> createState() => _IntropageState();
}

class _IntropageState extends State<Intropage> {
  // Future variables to store data fetched from Supabase
  late Future<List<Map<String, dynamic>>> _categoriesFuture;
  late Future<List<Map<String, dynamic>>> _workersFuture;

  @override
  void initState() {
    super.initState();
    // Fetch categories and workers data when the page initializes
    _categoriesFuture = fetchCategories();
    _workersFuture = fetchWorkers();
  }

  // Function to fetch categories from Supabase
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await Supabase.instance.client
        .from('category') // Replace 'category' with your table name
        .select()
        .order('created_at', ascending: false);

    if (response.isEmpty) {
      throw Exception('No categories found');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  // Function to fetch workers from Supabase
  Future<List<Map<String, dynamic>>> fetchWorkers() async {
    final response = await Supabase.instance.client
        .from('Giginfo') // Replace 'Giginfo' with your table name
        .select()
        .order('created_at', ascending: false);

    if (response.isEmpty) {
      throw Exception('No workers found');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  // Function to refresh categories data
  Future<void> _refreshCategories() async {
    setState(() {
      _categoriesFuture = fetchCategories();
    });
  }

  // Function to refresh workers data
  Future<void> _refreshWorkers() async {
    setState(() {
      _workersFuture = fetchWorkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue.shade700,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade700,
          brightness: Brightness.light,
        ),
        fontFamily: "roboto",
        useMaterial3: true,
      ),
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('lib/images/avatar.jpg'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Sonal Thilakarathna",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "I'm a Client",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        size: 28,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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

                    // Categories Section
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
                          return SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
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
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: AnimatedScale(
                                    scale: 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: CategoryCircle(
                                      categoryName: category['category_name'],
                                      categoryImage:
                                          category['category_icon'] ??
                                          'lib/images/caticon.png',
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

                    // Workers Section
                    const Padding(
                      padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                      child: Text(
                        "Available Workers",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _workersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No workers available.'),
                          );
                        } else {
                          final workers = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: workers.length,
                            itemBuilder: (context, index) {
                              final worker = workers[index];

                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => GigInsidePage(
                                                gigData: worker,
                                              ),
                                        ),
                                      );
                                    },
                                    child: GigCard(
                                      sellerName:
                                          worker['worker_name'] ?? 'Unknown',
                                      gigTitle:
                                          worker['Title'] ??
                                          'No title available.',
                                      thumbnailImage:
                                          worker['thumbnail_image'] ??
                                          'lib/images/gigimage.jpg',
                                      profileImage:
                                          worker['profile_image'] ??
                                          'lib/images/avatar.jpg',
                                      rating:
                                          (worker['rating'] as num?)
                                              ?.toDouble() ??
                                          0.0,
                                      reviews: worker['reviews'] ?? 0,
                                      price: (worker['Price']),
                                      isTopRated:
                                          worker['is_top_rated'] ?? false,
                                      gigId:
                                          worker['gig_id'], // Pass the gig_id here
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
