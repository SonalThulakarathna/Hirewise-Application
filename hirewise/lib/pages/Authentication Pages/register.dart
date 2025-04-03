import 'package:flutter/material.dart';
import 'package:hirewise/auth/auth_service.dart';
import 'package:hirewise/components/buildSocialButton.dart';

class IntroRegister extends StatefulWidget {
  const IntroRegister({super.key});

  @override
  State<IntroRegister> createState() => _IntroRegisterState();
}

class _IntroRegisterState extends State<IntroRegister> {
  final authService = AuthService();

  final emailControl = TextEditingController();
  final passwordControl = TextEditingController();
  final confirmPasswordControl = TextEditingController();
  final usernameControl = TextEditingController();

  bool _isLoading = false;

  void register() async {
    final email = emailControl.text;
    final password = passwordControl.text;
    final confirmPassword = confirmPasswordControl.text;
    final username = usernameControl.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await authService.signupWithEmailPassword(email, password, username);
      // Navigate to another screen after successful registration
      // Example: Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                    "Hello Register\nGet Started your journey",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Username field
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
                    controller: usernameControl,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter username",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Email field
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
                const SizedBox(height: 20),

                // Password field
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
                const SizedBox(height: 20),

                // Confirm password field
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
                    controller: confirmPasswordControl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Confirm password",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Sign up button
                ElevatedButton(
                  onPressed: _isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(34, 35, 37, 1),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color.fromRGBO(243, 243, 243, 1),
                              fontSize: 19,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Go back to login page
                      },
                      child: const Text(
                        "Login Here",
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
