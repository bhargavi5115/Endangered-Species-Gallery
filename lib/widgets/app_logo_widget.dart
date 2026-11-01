import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AppLogoWidget extends StatelessWidget {
  final double size;
  final bool showBorder;
  final bool showShadow;

  const AppLogoWidget({
    super.key,
    this.size = 64,
    this.showBorder = true,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: AppColors.sageGreen.withValues(alpha: 0.8),
                width: size > 80 ? 2.5 : 1.8,
              )
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.sageGreen.withValues(alpha: 0.35),
                  blurRadius: size * 0.25,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/icons/app_logo.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Elegant vector fallback if image is loading
            return Container(
              color: AppColors.deepGreen,
              child: Center(
                child: Icon(
                  Icons.pets,
                  color: AppColors.lightGreen,
                  size: size * 0.5,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
