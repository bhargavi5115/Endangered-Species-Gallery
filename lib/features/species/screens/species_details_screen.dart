import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/species_model.dart';
import '../../../services/image_service.dart';
import '../../../widgets/status_badge.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../home/providers/app_providers.dart';

class SpeciesDetailsScreen extends ConsumerWidget {
  final String speciesId;

  const SpeciesDetailsScreen({
    super.key,
    required this.speciesId,
  });

  void _shareSpecies(BuildContext context, SpeciesModel species) {
    final shareText = '''
🐾 ${species.commonName} (${species.scientificName})
IUCN Status: ${species.conservationStatus.code} - ${species.conservationStatus.fullName}
Category: ${species.category}
Habitat: ${species.habitat}
Geographic Range: ${species.geographicRange}

Learn more about wildlife conservation on the Endangered Species Gallery app!
''';
    Share.share(shareText, subject: 'Discover ${species.commonName}');
  }

  Future<void> _launchReferenceUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open reference: $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSpecies = ref.watch(speciesDetailFutureProvider(speciesId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoriteIds = ref.watch(favoritesProvider);
    final isFav = favoriteIds.contains(speciesId);

    return Scaffold(
      body: asyncSpecies.when(
        loading: () => const Scaffold(body: LoadingWidget(message: 'Enriching species profile with GBIF & IUCN data...')),
        error: (err, stack) => Scaffold(
          appBar: AppBar(),
          body: CustomErrorWidget(
            title: 'Species Not Found',
            message: err.toString(),
            onRetry: () => ref.refresh(speciesDetailFutureProvider(speciesId)),
          ),
        ),
        data: (species) {
          return CustomScrollView(
            slivers: [
              // Hero App Bar with Image
              SliverAppBar(
                expandedHeight: 330,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.primaryForestGreen,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  // Share Button
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.share, color: Colors.white, size: 20),
                    ),
                    onPressed: () => _shareSpecies(context, species),
                  ),
                  // Favorite Button
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.redAccent : Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggle(species.speciesId);
                    },
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      ImageService.buildCachedImage(
                        imageUrl: species.imageUrl,
                        semanticLabel: species.commonName,
                        fit: BoxFit.cover,
                      ),
                      // Top and Bottom gradient overlays
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                                Colors.black.withOpacity(0.85),
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Image Attribution pill
                      Positioned(
                        bottom: 60,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.photo_camera, size: 12, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text(
                                species.imageAttribution,
                                style: const TextStyle(color: Colors.white70, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Bottom Title in hero bar
                      Positioned(
                        bottom: 12,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                StatusBadge(status: species.conservationStatus, showFullName: true),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    species.category,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              species.commonName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              species.scientificName,
                              style: const TextStyle(
                                color: AppColors.lightGreen,
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Conservation Status Detailed Alert
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: species.conservationStatus.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: species.conservationStatus.color.withOpacity(0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: species.conservationStatus.color,
                              size: 26,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'IUCN Assessment: ${species.conservationStatus.fullName} (${species.conservationStatus.code})',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.5,
                                      color: species.conservationStatus.color,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    species.conservationStatus.description,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Assessed: ${species.assessmentDate} • Source: ${species.source}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Real-time GBIF Occurrence Badge
                      if (species.occurrenceCount != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.sageGreen.withOpacity(0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.analytics_outlined, color: AppColors.sageGreen, size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'GBIF Global Occurrence Records',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${species.occurrenceCount} verified museum & observational records indexed. (Note: occurrence records represent observations, not global population numbers).',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Habitat & Geographic Range
                      _buildSectionTitle(context, 'Habitat & Distribution', Icons.map_outlined),
                      const SizedBox(height: 8),
                      _buildInfoTile(
                        context,
                        'Natural Habitat',
                        species.habitat,
                        Icons.forest_outlined,
                      ),
                      const SizedBox(height: 6),
                      _buildInfoTile(
                        context,
                        'Geographic Range',
                        species.geographicRange,
                        Icons.public,
                      ),
                      const SizedBox(height: 20),

                      // Verified Population Info
                      _buildSectionTitle(context, 'Population Status', Icons.group_outlined),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: Text(
                          species.population,
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.45,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Scientific Taxonomy Card
                      _buildSectionTitle(context, 'Scientific Classification', Icons.account_tree_outlined),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(3),
                          },
                          children: [
                            _buildTableRow('Kingdom', species.kingdom),
                            _buildTableRow('Phylum', species.phylum),
                            _buildTableRow('Class', species.classTaxon),
                            _buildTableRow('Order', species.order),
                            _buildTableRow('Family', species.family),
                            _buildTableRow('Genus', species.genus),
                            _buildTableRow('Species', species.scientificName),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Major Survival Threats
                      _buildSectionTitle(context, 'Major Threats', Icons.report_problem_outlined),
                      const SizedBox(height: 8),
                      ...species.threats.map((threat) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Icon(Icons.error_outline, size: 16, color: AppColors.statusCR),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  threat,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 20),

                      // Conservation Initiatives
                      _buildSectionTitle(context, 'Conservation Initiatives', Icons.volunteer_activism_outlined),
                      const SizedBox(height: 8),
                      ...species.conservationActions.map((action) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Icon(Icons.check_circle_outline, size: 16, color: AppColors.success),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  action,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 20),

                      // Physical Characteristics & Diet
                      _buildSectionTitle(context, 'Biology & Characteristics', Icons.info_outline),
                      const SizedBox(height: 8),
                      _buildInfoTile(
                        context,
                        'Physical Characteristics',
                        species.physicalCharacteristics,
                        Icons.straighten,
                      ),
                      const SizedBox(height: 6),
                      _buildInfoTile(
                        context,
                        'Dietary Profile',
                        species.diet,
                        Icons.restaurant_outlined,
                      ),
                      const SizedBox(height: 20),

                      // Interesting Wildlife Facts
                      if (species.interestingFacts.isNotEmpty) ...[
                        _buildSectionTitle(context, 'Fascinating Wildlife Facts', Icons.lightbulb_outline),
                        const SizedBox(height: 8),
                        ...species.interestingFacts.map((fact) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.sageGreen.withOpacity(0.3)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.stars_rounded, color: AppColors.emeraldGreen, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    fact,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.deepGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                      ],

                      // Reference Links & Scientific Citations
                      if (species.referenceLinks.isNotEmpty) ...[
                        _buildSectionTitle(context, 'Scientific References & Data Sources', Icons.link),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: species.referenceLinks.entries.map((entry) {
                            return ActionChip(
                              avatar: const Icon(Icons.open_in_new, size: 14, color: AppColors.deepGreen),
                              label: Text(entry.key),
                              onPressed: () => _launchReferenceUrl(context, entry.value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.sageGreen),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.deepGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(BuildContext context, String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.sageGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.secondaryText),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            value.isNotEmpty ? value : 'N/A',
            style: const TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}

