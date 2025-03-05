import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String assetPath;

  const SocialButton({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Image.asset(assetPath, width: 32, height: 32),
    );
  }
}
