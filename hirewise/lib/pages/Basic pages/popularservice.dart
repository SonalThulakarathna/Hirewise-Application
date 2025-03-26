import 'package:flutter/material.dart';
import 'package:hirewise/components/gigcardtwo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Import your GigCardNew component

class PopularServicesPage extends StatefulWidget {
  const PopularServicesPage({super.key});

  @override
  State<PopularServicesPage> createState() => _PopularServicesPageState();
}

class _PopularServicesPageState extends State<PopularServicesPage> {
  late Future<List<Map<String, dynamic>>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = fetchServices(); // Fetch services on initialization
  }

  // Function to fetch services from Supabase
  Future<List<Map<String, dynamic>>> fetchServices() async {
    final response = await Supabase.instance.client
        .from('Giginfo') // Replace with your actual table name
        .select()
        .order('created_at', ascending: false);

    if (response.isEmpty) {
      throw Exception('No services found');
    }
    return List<Map<String, dynamic>>.from(response);
  }

  // Function to refresh services
  Future<void> _refreshServices() async {
    setState(() {
      _servicesFuture = fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Services'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshServices,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryChip(label: 'All', isSelected: true),
                      CategoryChip(label: 'Electrician'),
                      CategoryChip(label: 'Painting'),
                      CategoryChip(label: 'Tailor'),
                      CategoryChip(label: 'Machine Builder'),
                    ],
                  ),
                ),
              ),
              // Services List
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _servicesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No services available.'));
                  } else {
                    final services = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];

                        return Column(
                          children: [
                            GigCardNew(
                              sellerName: service['worker_name'] ?? 'Unknown',
                              gigTitle:
                                  service['Title'] ?? 'No title available.',
                              thumbnailImage:
                                  service['thumbnail_image'] ??
                                  'lib/images/gigimage.jpg',
                              profileImage:
                                  service['profile_image'] ??
                                  'lib/images/avatar.jpg',
                              rating:
                                  (service['rating'] as num?)?.toDouble() ??
                                  0.0,
                              reviews: service['reviews'] ?? 0,
                              price: service['Price'],
                              isTopRated: service['is_top_rated'] ?? false,
                            ),
                            const SizedBox(height: 30),
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
    );
  }
}

// Category Chip Widget
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const CategoryChip({super.key, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Implement chip selection logic
        },
      ),
    );
  }
}
