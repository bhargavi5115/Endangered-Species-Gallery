import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../features/home/providers/app_providers.dart';

class CategoryFilter extends ConsumerWidget {
  const CategoryFilter({super.key});

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Mammals':
        return Icons.pets;
      case 'Birds':
        return Icons.flutter_dash;
      case 'Reptiles':
        return Icons.landscape;
      case 'Amphibians':
        return Icons.water_drop;
      case 'Marine Animals':
        return Icons.waves;
      case 'Insects':
        return Icons.bug_report;
      default:
        return Icons.all_inclusive;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: AppConstants.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = AppConstants.categories[index];
          final isSelected = selectedCategory == category;

          return FilterChip(
            showCheckmark: false,
            avatar: Icon(
              _getCategoryIcon(category),
              size: 16,
              color: isSelected
                  ? (isDark ? Colors.white : AppColors.deepGreen)
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            label: Text(category),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                ref.read(selectedCategoryProvider.notifier).state = category;
              } else {
                ref.read(selectedCategoryProvider.notifier).state = 'All Categories';
              }
            },
            backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
            selectedColor: isDark ? AppColors.emeraldGreen : AppColors.lightGreen,
            labelStyle: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? (isDark ? Colors.white : AppColors.deepGreen)
                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected
                    ? (isDark ? AppColors.mintGreen : AppColors.emeraldGreen)
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: isSelected ? 1.5 : 1,
              ),
            ),
          );
        },
      ),
    );
  }
}
