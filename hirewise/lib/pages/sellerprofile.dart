import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SellerProfilePage extends StatefulWidget {
  final String sellerId;

  const SellerProfilePage({super.key, required this.sellerId});

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  final _supabase = Supabase.instance.client;
  Map<String, dynamic>? _sellerProfile;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSellerProfile();
  }

  Future<void> _loadSellerProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response =
          await _supabase
              .from('profiles')
              .select()
              .eq('id', widget.sellerId)
              .single();

      setState(() {
        _sellerProfile = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seller Profile')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _sellerProfile == null
              ? const Center(child: Text('No profile found'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Avatar and Name
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _sellerProfile!['avatar_url'] != null
                              ? NetworkImage(_sellerProfile!['avatar_url'])
                              : const AssetImage(
                                    'lib/images/default_avatar.png',
                                  )
                                  as ImageProvider,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _sellerProfile!['username'] ?? 'No Name',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // Bio Section
                    if (_sellerProfile!['bio'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _sellerProfile!['bio'],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
    );
  }
}
