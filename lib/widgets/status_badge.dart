import 'package:flutter/material.dart';
import '../core/constants/conservation_status.dart';

class StatusBadge extends StatelessWidget {
  final ConservationStatus status;
  final bool showFullName;
  final double fontSize;
  final EdgeInsets padding;

  const StatusBadge({
    super.key,
    required this.status,
    this.showFullName = false,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${status.code} - ${status.fullName}: ${status.description}',
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: status.color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: status.color.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status.code,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: fontSize,
                letterSpacing: 0.5,
              ),
            ),
            if (showFullName) ...[
              const SizedBox(width: 4),
              Text(
                '• ${status.fullName}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
