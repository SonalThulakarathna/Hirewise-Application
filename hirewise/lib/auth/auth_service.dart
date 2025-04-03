import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email, password, and username
  Future<AuthResponse> signupWithEmailPassword(
    String email,
    String password,
    String username,
  ) async {
    // First, sign up the user with email and password
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );

    // If there's an error during signup, throw it
    if (response.error != null) {
      throw Exception('Error during signup: ${response.error!.message}');
    }

    // After signup, get the new user ID
    final user = response.user;

    if (user != null) {
      // Store the username and user ID in the profiles table
      final profileResponse = await _supabase.from('profiles').upsert([
        {
          'id': user.id, // User's Supabase ID
          'username': username,
        },
      ]);

      if (profileResponse.error != null) {
        throw Exception(
          'Error storing profile data: ${profileResponse.error!.message}',
        );
      }
    }

    return response;
  }

  // Log out the user
  Future<void> signOut() async {
    return await _supabase.auth.signOut();
  }

  // Get the email of the current user
  String? getUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}

extension on AuthResponse {
  get error => null;
}
