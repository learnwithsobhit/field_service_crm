import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? primaryColor;
  final Color? secondaryColor;

  const AppLogo({
    super.key,
    this.size = 120,
    this.showText = true,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? const Color(0xFF14B8A6);
    final secondary = secondaryColor ?? const Color(0xFF0F172A);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Icon
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primary,
                primary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Main icon
              Center(
                child: Icon(
                  Icons.build_circle_rounded,
                  size: size * 0.5,
                  color: Colors.white,
                ),
              ),
              // Small gear icon overlay
              Positioned(
                top: size * 0.2,
                right: size * 0.2,
                child: Container(
                  width: size * 0.25,
                  height: size * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(size * 0.125),
                  ),
                  child: Icon(
                    Icons.settings,
                    size: size * 0.15,
                    color: Colors.white,
                  ),
                ),
              ),
              // Connection dots
              Positioned(
                bottom: size * 0.15,
                left: size * 0.15,
                child: Row(
                  children: [
                    _buildDot(Colors.white, size * 0.08),
                    SizedBox(width: size * 0.05),
                    _buildDot(Colors.white.withOpacity(0.7), size * 0.08),
                    SizedBox(width: size * 0.05),
                    _buildDot(Colors.white.withOpacity(0.4), size * 0.08),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 16),
          // App Name
          Text(
            'FieldService',
            style: TextStyle(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
              color: secondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          // Tagline
          Text(
            'Professional CRM',
            style: TextStyle(
              fontSize: size * 0.12,
              color: secondary.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// Compact version for app bars and small spaces
class AppLogoCompact extends StatelessWidget {
  final double size;
  final Color? primaryColor;

  const AppLogoCompact({
    super.key,
    this.size = 32,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? const Color(0xFF14B8A6);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary,
            primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.build_circle_rounded,
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }
} 