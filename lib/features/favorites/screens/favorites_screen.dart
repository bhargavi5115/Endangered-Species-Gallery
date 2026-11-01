import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../widgets/species_card.dart';
import '../../../widgets/empty_state.dart';
import '../../home/providers/app_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  final VoidCallback? onNavigateToExplore;

  const FavoritesScreen({
    super.key,
    this.onNavigateToExplore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteSpeciesListProvider);
    final user = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Saved Species'),
        actions: [
          if (favorites.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  '${favorites.length} Saved',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.sageGreen : AppColors.deepGreen,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Storage / Sync Status Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: user != null && !user.isGuest
                  ? AppColors.emeraldGreen.withOpacity(0.12)
                  : Colors.orange.withOpacity(0.12),
              border: Border(
                bottom: BorderSide(
                  color: user != null && !user.isGuest
                      ? AppColors.emeraldGreen.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  user != null && !user.isGuest ? Icons.cloud_done : Icons.cloud_off_outlined,
                  size: 16,
                  color: user != null && !user.isGuest ? AppColors.emeraldGreen : Colors.orange.shade800,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user != null && !user.isGuest
                        ? 'Cloud Synced with Firebase Account (${user.email})'
                        : 'Local Guest Mode • Favorites saved on this device only',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: user != null && !user.isGuest ? AppColors.emeraldGreen : Colors.orange.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: favorites.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.favorite_border,
                    title: 'No Saved Species Yet',
                    message:
                        'Bookmark animals by tapping the heart icon on any species card to build your personalized conservation collection.',
                    actionLabel: 'Explore Animals',
                    onAction: onNavigateToExplore,
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.getGridColumnCount(context),
                      childAspectRatio: Responsive.getCardAspectRatio(context),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final species = favorites[index];
                      return SpeciesCard(
                        species: species,
                        onFavoriteToggle: () {
                          // Handled automatically via riverpod
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
