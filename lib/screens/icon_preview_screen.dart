import 'package:flutter/material.dart';
import '../widgets/simple_app_icon.dart';

class IconPreviewScreen extends StatelessWidget {
  const IconPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SimpleAppIcon(size: 200),
            const SizedBox(height: 40),
            const Text(
              'App Icon Preview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Take a screenshot of this icon\nand save it as app_icon_1024.png',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 