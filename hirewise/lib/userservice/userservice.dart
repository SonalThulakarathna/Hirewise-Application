import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> getCurrentUserId() async {
    return _supabase.auth.currentUser?.id;
  }

  Future<bool> updateUsername(String newUsername) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await _supabase
          .from('profiles')
          .update({'username': newUsername})
          .eq('id', userId);

      return response.error == null;
    } catch (e) {
      print("Error updating username: $e");
      return false;
    }
  }

  Future<String> getUsername() async {
    final userId = await getCurrentUserId();
    if (userId == null) return 'Guest User';

    try {
      final response =
          await _supabase
              .from('profiles')
              .select('username')
              .eq('id', userId)
              .single();

      return response['username'] ?? 'Guest User';
    } catch (e) {
      print('Error fetching username: $e');
      return 'Guest User';
    }
  }

  Future<Map<String, dynamic>> getFullProfile() async {
    try {
      final userId = await getCurrentUserId();
      if (userId == null) return _defaultProfile();

      final response =
          await _supabase
              .from('profiles')
              .select('username, email, avatar_url')
              .eq('id', userId)
              .single();

      return response;
    } catch (e) {
      print('Error fetching profile: $e');
      return _defaultProfile();
    }
  }

  Map<String, dynamic> _defaultProfile() {
    return {
      'username': 'Guest User',
      'email': 'guest@example.com',
      'avatar_url': null,
    };
  }
}
