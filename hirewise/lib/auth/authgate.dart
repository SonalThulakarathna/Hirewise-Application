import 'package:flutter/material.dart';
import 'package:hirewise/pages/intropage.dart' show Intropage;
import 'package:hirewise/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check if there is a valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        // Navigate to ProfilePage if session exists, otherwise to LoginPage
        if (session != null) {
          return const Intropage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
