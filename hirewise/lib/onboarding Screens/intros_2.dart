import 'package:flutter/material.dart';

class Intros2 extends StatelessWidget {
  const Intros2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Modern card container for the image
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/onboarding2.png',
                    height: 220,
                    width: 220,
                  ),
                ),

                const SizedBox(height: 40),

                // Animated title with gradient text
                ShaderMask(
                  shaderCallback:
                      (bounds) => LinearGradient(
                        colors: [Colors.blue.shade700, Colors.blue.shade500],
                      ).createShader(bounds),
                  child: const Text(
                    "Find Reliable Workers Near You",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      height: 1.2,
                      color:
                          Colors.white, // This will be overridden by the shader
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Improved description with better typography
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Discover skilled professionals in your area for all your needs. From home repairs to personal services, we've got you covered.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Color(0xFF6B7280), // Modern gray color
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // Modern call-to-action button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Location indicator with modern design
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 24,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Based on your location",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
