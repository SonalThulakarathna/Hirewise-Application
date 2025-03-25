import 'dart:core';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  //sign in with email password
  // ignore: non_constant_identifier_names
  Future<AuthResponse> SignInwithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  //signiup with email and password

  Future<AuthResponse> signupwithEmailPassword(
    String email,
    String password,
    String username,
  ) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

  //logout

  Future<void> signout() async {
    return await _supabase.auth.signOut();
  }

  String? getuseremail() {
    final Session = _supabase.auth.currentSession;
    final user = Session?.user;
    return user?.email;
  }
}
