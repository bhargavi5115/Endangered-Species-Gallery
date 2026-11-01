import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_colors.dart';

class ImageService {
  /// Builds a cached image with consistent loading spinner and graceful wildlife fallback
  static Widget buildCachedImage({
    required String imageUrl,
    required String semanticLabel,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    Widget imageWidget;

    if (imageUrl.startsWith('assets/')) {
      // Local bundled asset - zero network latency, authentic verified photo
      imageWidget = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: semanticLabel,
        errorBuilder: (context, error, stackTrace) => _buildErrorFallback(width, height),
      );
    } else if (kIsWeb) {
      // On Web, Image.network uses browser-native decoding which supports CORS images seamlessly
      imageWidget = Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: semanticLabel,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: AppColors.lightGreen.withValues(alpha: 0.3),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.emeraldGreen),
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildErrorFallback(width, height),
      );
    } else {
      // On mobile / desktop platforms, use CachedNetworkImage for disk caching
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: AppColors.lightGreen.withValues(alpha: 0.3),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.emeraldGreen),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildErrorFallback(width, height),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Semantics(
          label: semanticLabel,
          child: imageWidget,
        ),
      );
    }

    return Semantics(
      label: semanticLabel,
      child: imageWidget,
    );
  }

  static Widget _buildErrorFallback(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pets, color: AppColors.sageGreen, size: 36),
          const SizedBox(height: 6),
          Text(
            'Wildlife Photography Archive',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
