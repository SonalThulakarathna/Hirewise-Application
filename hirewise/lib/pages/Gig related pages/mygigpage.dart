import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnhancedGigPage extends StatefulWidget {
  const EnhancedGigPage({super.key});

  @override
  State<EnhancedGigPage> createState() => _EnhancedGigPageState();
}

class _EnhancedGigPageState extends State<EnhancedGigPage> {
  late Future<List<Map<String, dynamic>>> _gigsFuture;
  final SupabaseClient _supabase = Supabase.instance.client;

  // Filter options
  final List<String> _filterOptions = ['All', 'Active', 'Paused', 'Draft'];
  String _selectedFilter = 'All';

  // Fetch gigs for the logged-in user
  Future<List<Map<String, dynamic>>> _fetchGigs() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }
    final response = await _supabase
        .from('Giginfo') // Replace 'gigs' with your actual table name
        .select()
        .eq('user_id', user.id) // Filtering gigs by the logged-in user
        .order('created_at', ascending: false); // Order by creation date
    return List<Map<String, dynamic>>.from(response);
  }

  // Refresh gigs
  Future<void> _refreshGigs() async {
    setState(() {
      _gigsFuture = _fetchGigs();
    });
  }

  @override
  void initState() {
    super.initState();
    _gigsFuture = _fetchGigs(); // Call the function to fetch gigs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text(
          'My Gigs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF222325),
          ),
        ),
        backgroundColor: const Color(0xFFF3F3F3),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF222325)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Create a new gig')));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshGigs,
        color: Colors.black,
        child: Column(
          children: [
            // Stats summary section
            _buildStatsSummary(),

            // Filter section
            _buildFilterSection(),

            // Gigs list
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _gigsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingState();
                  } else if (snapshot.hasError) {
                    return _buildErrorState(snapshot.error.toString());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState();
                  } else {
                    final gigs = snapshot.data!;
                    // Filter gigs based on selected filter
                    final filteredGigs =
                        _selectedFilter == 'All'
                            ? gigs
                            : gigs
                                .where(
                                  (gig) =>
                                      (gig['status'] ?? 'Active') ==
                                      _selectedFilter,
                                )
                                .toList();

                    if (filteredGigs.isEmpty) {
                      return _buildNoFilterResultsState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredGigs.length,
                      itemBuilder: (context, index) {
                        return _buildGigCard(filteredGigs[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Create a new gig')));
        },
        backgroundColor: const Color(0xFF222325),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsSummary() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _gigsFuture,
      builder: (context, snapshot) {
        // Default values
        int totalGigs = 0;
        int activeGigs = 0;
        int totalViews = 0;

        // Calculate if data is available
        if (snapshot.hasData) {
          totalGigs = snapshot.data!.length;
          activeGigs =
              snapshot.data!
                  .where((gig) => (gig['status'] ?? 'Active') == 'Active')
                  .length;
          // Assuming each gig has a 'views' field, otherwise use a default value
          totalViews = snapshot.data!.fold(
            0,
            (sum, gig) => sum + (gig['views'] as int? ?? 0),
          );
        }

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF222325),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                totalGigs.toString(),
                'Total Gigs',
                Icons.work_outline,
              ),
              _buildStatItem(
                activeGigs.toString(),
                'Active',
                Icons.check_circle_outline,
              ),
              _buildStatItem(
                totalViews.toString(),
                'Views',
                Icons.visibility_outlined,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF222325)
                        : const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color:
                      isSelected
                          ? const Color(0xFF222325)
                          : Colors.grey.shade300,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF222325),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGigCard(Map<String, dynamic> gig) {
    // Determine status (default to 'Active' if not specified)
    final status = gig['status'] ?? 'Active';

    // Determine status color
    Color statusColor;
    switch (status) {
      case 'Active':
        statusColor = Colors.green;
        break;
      case 'Paused':
        statusColor = Colors.orange;
        break;
      case 'Draft':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gig image and status badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child:
                    gig['image_url'] != null &&
                            gig['image_url'].toString().isNotEmpty
                        ? Image.network(
                          gig['image_url'],
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        )
                        : Container(
                          height: 180,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (gig['is_featured'] == true)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.star, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Featured',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Gig details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and category
                Text(
                  gig['Title'] ?? 'Untitled Gig',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Price and stats
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${gig['Price'] ?? 'N/A'}€',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _buildGigStat(
                      Icons.star,
                      '${gig['rating'] ?? '0.0'}',
                      Colors.amber,
                    ),
                    const SizedBox(width: 16),
                    _buildGigStat(
                      Icons.visibility_outlined,
                      '${gig['views'] ?? '0'}',
                      Colors.grey.shade700,
                    ),
                    const SizedBox(width: 16),
                    _buildGigStat(
                      Icons.shopping_bag_outlined,
                      '${gig['orders'] ?? '0'}',
                      Colors.black,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Edit gig: ${gig['Title'] ?? 'Untitled'}',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF222325),
                          side: const BorderSide(color: Color(0xFF222325)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'View gig: ${gig['Title'] ?? 'Untitled'}',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.visibility_outlined),
                        label: const Text('Preview'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF222325),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                if (status == 'Paused')
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Action to activate the gig
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Activate gig: ${gig['Title'] ?? 'Untitled'}',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Activate Gig'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGigStat(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.black),
          const SizedBox(height: 16),
          Text(
            'Loading your gigs...',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.black),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshGigs,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_off_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Gigs Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t created any gigs yet. Create your first gig to start selling your services.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Action to create a new gig
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create a new gig')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Your First Gig'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoFilterResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_list, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No $_selectedFilter Gigs',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You don\'t have any gigs with the $_selectedFilter status. Try changing the filter.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'All';
                });
              },
              icon: const Icon(Icons.filter_alt_off),
              label: const Text('Show All Gigs'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
