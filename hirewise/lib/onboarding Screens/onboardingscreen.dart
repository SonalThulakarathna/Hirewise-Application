import 'package:flutter/material.dart';
import 'package:hirewise/onboarding%20Screens/intros_1.dart';
import 'package:hirewise/onboarding%20Screens/intros_2.dart';
import 'package:hirewise/onboarding%20Screens/intros_3.dart';
import 'package:hirewise/pages/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Import the HomeScreen

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {
  final PageController _controller = PageController();

  bool onLastpage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                onLastpage = (index == 2);
              });
            },
            controller: _controller,
            children: [Intros1(), Intros2(), Intros3()],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Text("Skip"),
                  onTap: () {
                    _controller.jumpToPage(3);
                  },
                ),

                SmoothPageIndicator(controller: _controller, count: 3),

                onLastpage
                    ? GestureDetector(
                      child: Text("Done"),
                      onTap: () {
                        // Navigate to HomeScreen when "Done" is clicked
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    )
                    : GestureDetector(
                      child: Text("Next"),
                      onTap: () {
                        _controller.nextPage(
                          duration: Duration(
                            milliseconds: 500,
                          ), // Corrected duration
                          curve: Curves.easeIn,
                        );
                      },
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
