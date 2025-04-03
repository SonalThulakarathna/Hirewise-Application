import 'package:flutter/material.dart';
import 'package:hirewise/components/gigcard.dart';
import 'package:hirewise/pages/Gig%20related%20pages/Giginsidepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryGigsPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryGigsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryGigsPage> createState() => _CategoryGigsPageState();
}

class _CategoryGigsPageState extends State<CategoryGigsPage> {
  late Future<List<Map<String, dynamic>>> _gigsFuture;
  final SupabaseClient _supabase = Supabase.instance.client;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  List<Map<String, dynamic>> _allGigs = [];

  @override
  void initState() {
    super.initState();
    _loadInitialGigs();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialGigs() async {
    setState(() {
      _gigsFuture = _fetchGigsByCategory();
    });
  }

  Future<void> _loadMoreGigs() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    try {
      final newGigs = await _fetchGigsByCategory(page: _currentPage);
      setState(() {
        _allGigs.addAll(newGigs);
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
        _currentPage--;
      });
      debugPrint('Error loading more gigs: $e');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_scrollController.position.outOfRange) {
      _loadMoreGigs();
    }
  }

  Future<List<Map<String, dynamic>>> _fetchGigsByCategory({
    int page = 0,
  }) async {
    try {
      final from = page * _itemsPerPage;
      final to = (page + 1) * _itemsPerPage - 1;

      final response = await _supabase
          .from('Giginfo')
          .select('''
            *,
            profiles:user_id (username, avatar_url)
          ''')
          .eq('category_id', widget.categoryId)
          .order('created_at', ascending: false)
          .range(from, to);

      if (page == 0) {
        _allGigs = List<Map<String, dynamic>>.from(response);
      }
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching gigs: $e');
      throw Exception('Failed to load gigs. Please try again.');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _currentPage = 0;
      _allGigs = [];
      _gigsFuture = _fetchGigsByCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.categoryName} Gigs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _gigsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                _allGigs.isEmpty) {
              return _buildLoadingIndicator();
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error.toString());
            } else if (!snapshot.hasData || _allGigs.isEmpty) {
              return _buildEmptyWidget();
            }

            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _allGigs.length + (_isLoadingMore ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index >= _allGigs.length) {
                  return _buildLoadingMoreIndicator();
                }

                final gig = _allGigs[index];
                final profile = gig['profiles'] as Map<String, dynamic>? ?? {};

                return GigCardnew(
                  sellerName: profile['username']?.toString() ?? 'Anonymous',
                  gigTitle: gig['Title']?.toString() ?? 'Untitled Gig',
                  thumbnailImage: gig['image_url']?.toString(),
                  profileImage:
                      profile['avatar_url']?.toString() ??
                      'lib/images/avatar.jpg',
                  price: gig['Price']?.toString() ?? 'N/A',
                  gigId: gig['id']?.toString() ?? 'unknown',
                  rating: (gig['rating'] as num?)?.toDouble(),
                  reviews: gig['reviews'] as int?,
                  isTopRated: gig['is_top_rated'] as bool? ?? false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GigInsidePage(gigData: gig),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Theme.of(context).primaryColor),
          const SizedBox(height: 16),
          Text(
            'Loading ${widget.categoryName} gigs...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshData,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No gigs found for ${widget.categoryName}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: _refreshData, child: const Text('Refresh')),
        ],
      ),
    );
  }
}
