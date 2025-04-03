import 'package:flutter/material.dart';
import 'package:hirewise/components/content_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryGigsList extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryGigsList({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryGigsList> createState() => _CategoryGigsListState();
}

class _CategoryGigsListState extends State<CategoryGigsList> {
  final _supabase = Supabase.instance.client;
  final List<Map<String, dynamic>> _gigs = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadGigs();
  }

  Future<void> _loadGigs() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final data = await _supabase
          .from('Giginfo')
          .select('*, profiles:user_id (username, avatar_url)')
          .eq('category_id', widget.categoryId)
          .order('created_at', ascending: false);

      setState(() {
        _gigs.addAll(List<Map<String, dynamic>>.from(data));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _gigs.clear();
    });
    await _loadGigs();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _gigs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_errorMessage'),
            ElevatedButton(onPressed: _loadGigs, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_gigs.isEmpty) {
      return Center(child: Text('No gigs found for ${widget.categoryName}'));
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _gigs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final gig = _gigs[index];
          final profile = gig['profiles'] as Map<String, dynamic>? ?? {};

          return GigCard(
            sellerName: profile['username']?.toString() ?? 'Anonymous',
            gigTitle: gig['Title']?.toString() ?? 'Untitled Gig',
            thumbnailImage: gig['image_url']?.toString(),
            profileImage:
                profile['avatar_url']?.toString() ?? 'lib/images/avatar.jpg',
            price: gig['Price']?.toString() ?? 'N/A',
            gigId: gig['id']?.toString() ?? 'unknown',
            onTap: () {
              // Handle navigation to gig details
            },
          );
        },
      ),
    );
  }
}
