import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final supabase = Supabase.instance.client;

  Future<String?> getCurrentUserName() async {
    try {
      // Get the current authenticated user
      final user = supabase.auth.currentUser;
      if (user == null) return null; // No user logged in

      // Fetch user details from 'users' table
      final response =
          await supabase
              .from('users') // Assuming table name is 'users'
              .select('name') // Fetch only 'name' column
              .eq('id', user.id) // Match the user ID
              .single(); // Expect a single record

      return response['name']; // Return the user name
    } catch (error) {
      print("Error fetching user name: $error");
      return null;
    }
  }
}
