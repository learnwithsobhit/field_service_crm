import 'package:flutter/material.dart';

class SimpleAppIcon extends StatelessWidget {
  final double size;

  const SimpleAppIcon({
    super.key,
    this.size = 1024,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF14B8A6),
            Color(0xFF0F766E),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Center(
        child: Icon(
          Icons.build_circle_rounded,
          size: size * 0.5,
          color: Colors.white,
        ),
      ),
    );
  }
} 