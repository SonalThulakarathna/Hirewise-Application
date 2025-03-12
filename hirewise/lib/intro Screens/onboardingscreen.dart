import 'package:flutter/material.dart';
import 'package:hirewise/intro%20Screens/intros_1.dart';
import 'package:hirewise/intro%20Screens/intros_2.dart';
import 'package:hirewise/intro%20Screens/intros_3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {
  PageController _controller = PageController();

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
                      child: Text("Done "),
                      onTap: () {
                        _controller.nextPage(
                          duration: Duration(microseconds: 5000),
                          curve: Curves.easeIn,
                        );
                      },
                    )
                    : GestureDetector(
                      child: Text("next "),
                      onTap: () {
                        _controller.nextPage(
                          duration: Duration(microseconds: 5000),
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
