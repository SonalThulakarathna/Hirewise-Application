import 'package:flutter/material.dart';
import 'package:hirewise/components/buildSocialButton.dart';

class IntroRegister extends StatefulWidget {
  const IntroRegister({super.key});

  @override
  State<IntroRegister> createState() => _IntroRegisterState();
}

class _IntroRegisterState extends State<IntroRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      body: SafeArea(
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

              //text fields

              //email
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                    247,
                    248,
                    250,
                    1,
                  ), // Fixed opacity (0-1)
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // Optional: Add border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 2), // Changes shadow position
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter username",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                    ), // Add padding
                  ),
                ),
              ),
              //password
              const SizedBox(height: 30),

              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                    247,
                    248,
                    250,
                    1,
                  ), // Fixed opacity (0-1)
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // Optional: Add border radius
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 2), // Changes shadow position
                    ),
                  ],
                ),
                child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter email",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                    ), // Add padding
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                    247,
                    248,
                    250,
                    1,
                  ), // Fixed opacity (0-1)
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // Optional: Add border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 2), // Changes shadow position
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter password",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                    ), // Add padding
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                    247,
                    248,
                    250,
                    1,
                  ), // Fixed opacity (0-1)
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // Optional: Add border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 2), // Changes shadow position
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "confirm password",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                    ), // Add padding
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Container(
                padding: EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Color.fromRGBO(34, 35, 37, 1),

                  borderRadius: BorderRadius.circular(8),
                ),

                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Sign in",
                    style: TextStyle(
                      color: Color.fromRGBO(243, 243, 243, 1),
                      fontSize: 19,
                      fontWeight: FontWeight.w100,
                      height: 1.3,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dont have an account ? "),
                  Text(
                    "Register Here ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              Row(
                children: [
                  Container(decoration: BoxDecoration(color: Colors.black)),
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
    );
  }
}
