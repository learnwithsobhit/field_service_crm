import 'package:flutter/material.dart';
import 'app_logo.dart';

class BrandHeader extends StatelessWidget {
  final double logoSize;
  final bool showTagline;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  const BrandHeader({
    super.key,
    this.logoSize = 80,
    this.showTagline = true,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLogo(
            size: logoSize,
            showText: false,
          ),
          if (showTagline) ...[
            const SizedBox(height: 16),
            Text(
              'FieldService',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF14B8A6),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Professional Field Service CRM',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class BrandHeaderCompact extends StatelessWidget {
  final double logoSize;
  final bool showText;

  const BrandHeaderCompact({
    super.key,
    this.logoSize = 40,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogoCompact(size: logoSize),
        if (showText) ...[
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'FieldService',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF14B8A6),
                ),
              ),
              Text(
                'CRM',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
} 