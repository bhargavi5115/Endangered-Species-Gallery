import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/conservation_status.dart';
import '../features/home/providers/app_providers.dart';

class StatusFilterBar extends ConsumerWidget {
  const StatusFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(selectedStatusProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All Statuses" Chip
          ChoiceChip(
            label: const Text('All Statuses'),
            selected: selectedStatus == null,
            onSelected: (selected) {
              if (selected) {
                ref.read(selectedStatusProvider.notifier).state = null;
              }
            },
            selectedColor: isDark ? AppColors.cardDark : AppColors.deepGreen,
            backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
            labelStyle: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: selectedStatus == null
                  ? Colors.white
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Individual IUCN Status Badges
          ...ConservationStatus.values.map((status) {
            final isSelected = selectedStatus == status;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                showCheckmark: false,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: status.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text('${status.code} - ${status.fullName}'),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  ref.read(selectedStatusProvider.notifier).state = selected ? status : null;
                },
                backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                selectedColor: status.color.withOpacity(0.2),
                labelStyle: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? status.color
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: isSelected ? status.color : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
