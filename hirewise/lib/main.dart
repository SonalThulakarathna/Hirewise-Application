import 'package:flutter/material.dart';
import 'package:hirewise/pages/intro_login_page.dart' show loginpage;
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://qwlidwutyairqbuzgnko.supabase.co",

    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF3bGlkd3V0eWFpcnFidXpnbmtvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDExMDM2MDEsImV4cCI6MjA1NjY3OTYwMX0.noAwWW8f-17sKzdZ1Gx1sHqrics6GE7_buKq3o04aoc",
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: loginpage(),
    );
  }
}
