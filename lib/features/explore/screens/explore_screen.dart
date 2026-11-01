import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../widgets/species_card.dart';
import '../../../widgets/search_widget.dart';
import '../../../widgets/category_filter.dart';
import '../../../widgets/status_filter.dart';
import '../../../widgets/empty_state.dart';
import '../../home/providers/app_providers.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speciesList = ref.watch(speciesListProvider);
    final sortOption = ref.watch(sortOptionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Biodiversity'),
        actions: [
          // Sort Dropdown Button
          PopupMenuButton<String>(
            tooltip: 'Sort Species',
            icon: const Icon(Icons.sort),
            initialValue: sortOption,
            onSelected: (value) {
              ref.read(sortOptionProvider.notifier).state = value;
            },
            itemBuilder: (context) {
              return AppConstants.sortOptions.map((option) {
                return PopupMenuItem<String>(
                  value: option,
                  child: Row(
                    children: [
                      if (sortOption == option)
                        const Icon(Icons.check, size: 16, color: AppColors.emeraldGreen)
                      else
                        const SizedBox(width: 16),
                      const SizedBox(width: 8),
                      Text(option, style: const TextStyle(fontSize: 13.5)),
                    ],
                  ),
                );
              }).toList();
            },
          ),
          IconButton(
            tooltip: 'Reset Filters',
            icon: const Icon(Icons.filter_alt_off),
            onPressed: () {
              ref.read(searchQueryProvider.notifier).state = '';
              ref.read(selectedCategoryProvider.notifier).state = 'All Categories';
              ref.read(selectedStatusProvider.notifier).state = null;
              ref.read(sortOptionProvider.notifier).state = 'Threat Level (Highest)';
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchWidget(hintText: 'Search species, genus, habitat...'),
          ),
          const SizedBox(height: 6),
          const CategoryFilter(),
          const SizedBox(height: 10),
          const StatusFilterBar(),
          const SizedBox(height: 10),

          // Count and Active Sort Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${speciesList.length} Species Records',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.sageGreen : AppColors.deepGreen,
                  ),
                ),
                Text(
                  'Sorted: $sortOption',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 12),

          // Species Grid
          Expanded(
            child: speciesList.isEmpty
                ? EmptyStateWidget(
                    title: 'No Species Found',
                    message: 'Try adjusting your search query or removing category/status filters.',
                    actionLabel: 'Clear All Filters',
                    onAction: () {
                      ref.read(searchQueryProvider.notifier).state = '';
                      ref.read(selectedCategoryProvider.notifier).state = 'All Categories';
                      ref.read(selectedStatusProvider.notifier).state = null;
                    },
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.getGridColumnCount(context),
                      childAspectRatio: Responsive.getCardAspectRatio(context),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: speciesList.length,
                    itemBuilder: (context, index) {
                      final species = speciesList[index];
                      return SpeciesCard(species: species);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
