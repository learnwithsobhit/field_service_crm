import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AppIconGenerator extends StatelessWidget {
  final double size;
  final bool showBackground;

  const AppIconGenerator({
    super.key,
    this.size = 1024,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: showBackground ? BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF14B8A6),
            Color(0xFF0F766E),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
      ) : null,
      child: CustomPaint(
        painter: AppIconPainter(),
        size: Size(size, size),
      ),
    );
  }
}

class AppIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = size.width * 0.02;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    // Draw main gear circle
    canvas.drawCircle(center, radius, strokePaint);
    canvas.drawCircle(center, radius, paint..color = Colors.white.withOpacity(0.9));

    // Draw gear teeth
    final teethLength = radius * 0.3;
    final teethWidth = size.width * 0.025;
    
    // Vertical teeth
    canvas.drawRect(
      Rect.fromLTWH(center.dx - teethWidth/2, center.dy - radius, teethWidth, teethLength),
      paint..color = Colors.white
    );
    canvas.drawRect(
      Rect.fromLTWH(center.dx - teethWidth/2, center.dy + radius - teethLength, teethWidth, teethLength),
      paint..color = Colors.white
    );

    // Horizontal teeth
    canvas.drawRect(
      Rect.fromLTWH(center.dx - radius, center.dy - teethWidth/2, teethLength, teethWidth),
      paint..color = Colors.white
    );
    canvas.drawRect(
      Rect.fromLTWH(center.dx + radius - teethLength, center.dy - teethWidth/2, teethLength, teethWidth),
      paint..color = Colors.white
    );

    // Diagonal teeth
    final diagonalOffset = radius * 0.7;
    final diagonalLength = teethLength * 0.8;
    
    // Top-left to bottom-right diagonal
    canvas.drawRect(
      Rect.fromLTWH(center.dx - diagonalOffset, center.dy - diagonalOffset, diagonalLength, teethWidth),
      paint..color = Colors.white
    );
    canvas.drawRect(
      Rect.fromLTWH(center.dx + diagonalOffset - diagonalLength, center.dy + diagonalOffset - teethWidth, diagonalLength, teethWidth),
      paint..color = Colors.white
    );

    // Top-right to bottom-left diagonal
    canvas.drawRect(
      Rect.fromLTWH(center.dx + diagonalOffset - diagonalLength, center.dy - diagonalOffset, diagonalLength, teethWidth),
      paint..color = Colors.white
    );
    canvas.drawRect(
      Rect.fromLTWH(center.dx - diagonalOffset, center.dy + diagonalOffset - teethWidth, diagonalLength, teethWidth),
      paint..color = Colors.white
    );

    // Draw inner circle
    final innerRadius = radius * 0.4;
    canvas.drawCircle(center, innerRadius, paint..color = Colors.white.withOpacity(0.9));

    // Draw center wrench icon
    final wrenchSize = innerRadius * 0.6;
    final wrenchPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF14B8A6)
      ..strokeWidth = size.width * 0.015
      ..strokeCap = StrokeCap.round;

    // Draw wrench
    final path = Path();
    path.moveTo(center.dx - wrenchSize, center.dy - wrenchSize * 0.3);
    path.lineTo(center.dx - wrenchSize * 0.3, center.dy - wrenchSize);
    path.lineTo(center.dx + wrenchSize * 0.3, center.dy - wrenchSize * 0.3);
    path.lineTo(center.dx + wrenchSize, center.dy - wrenchSize);
    
    path.moveTo(center.dx - wrenchSize, center.dy + wrenchSize * 0.3);
    path.lineTo(center.dx - wrenchSize * 0.3, center.dy + wrenchSize);
    path.lineTo(center.dx + wrenchSize * 0.3, center.dy + wrenchSize * 0.3);
    path.lineTo(center.dx + wrenchSize, center.dy + wrenchSize);
    
    canvas.drawPath(path, wrenchPaint);

    // Draw center dot
    canvas.drawCircle(center, size.width * 0.015, paint..color = const Color(0xFF14B8A6));

    // Draw connection dots
    final dotRadius = size.width * 0.02;
    final dotPositions = [
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.8),
    ];

    for (final position in dotPositions) {
      canvas.drawCircle(position, dotRadius, paint..color = Colors.white.withOpacity(0.8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 