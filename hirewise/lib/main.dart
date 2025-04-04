import 'package:flutter/material.dart';
import 'package:hirewise/pages/Authentication%20Pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://ocgwcnwudqfrgiblazzs.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9jZ3djbnd1ZHFmcmdpYmxhenpzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE2Nzk2MDIsImV4cCI6MjA1NzI1NTYwMn0.A4xPw7XRFNm24-A_jJHjxkkfVrmbYrOC6jzsYTRLg_o",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hirewise',
      // This will follow the system theme
      home: LoginPage(),
    );
  }
}
