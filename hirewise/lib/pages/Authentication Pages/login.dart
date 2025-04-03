import 'package:flutter/material.dart';
import 'package:hirewise/auth/auth_service.dart';
import 'package:hirewise/components/buildSocialButton.dart';
// Import the IntroPage
import 'package:hirewise/pages/Authentication%20Pages/register.dart';
import 'package:hirewise/pages/bottomnavbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// ignore: camel_case_types
class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  final emailControl = TextEditingController();
  final passwordControl = TextEditingController();

  bool _isLoading = false;

  void login() async {
    final email = emailControl.text;
    final password = passwordControl.text;
    setState(() {
      _isLoading = true; // Show the loading spinner
    });

    try {
      await authService.signInWithEmailPassword(email, password);
      // If successful, navigate to IntroPage
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Intropagebottom()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      setState(() {
        _isLoading = false; // Hide the loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 243, 243, 1),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    "Welcome back!\nGlad to see you, Again!",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Email text field
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(247, 248, 250, 1),
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: emailControl,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter email",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Password text field
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(247, 248, 250, 1),
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: passwordControl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter password",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Sign in button
                _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(),
                    ) // Show loading spinner when logging in
                    : GestureDetector(
                      onTap: login,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(34, 35, 37, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign in",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(243, 243, 243, 1),
                              fontSize: 19,
                              fontWeight: FontWeight.w100,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IntroRegister(),
                          ),
                        );
                      },
                      child: const Text(
                        "Register Here",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    "Or continue with",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialButton(assetPath: 'lib/images/apple.png'),
                    const SizedBox(width: 25),
                    SocialButton(assetPath: 'lib/images/Google (Button).png'),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
