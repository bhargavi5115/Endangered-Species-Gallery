import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/educational_content_model.dart';
import '../../../services/image_service.dart';
import '../../home/providers/app_providers.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(educationalArticlesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conservation Knowledge'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: articles.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final article = articles[index];
          return _buildArticleCard(context, article, isDark);
        },
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, EducationalContentModel article, bool isDark) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(12),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ImageService.buildCachedImage(
            imageUrl: article.imageUrl,
            semanticLabel: article.title,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          article.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.deepGreen,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  article.category,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.lightGreen : AppColors.deepGreen,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.schedule, size: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              const SizedBox(width: 4),
              Text(
                '${article.readTimeMinutes} min read',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        children: [
          const Divider(height: 16),
          Text(
            article.subtitle,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: isDark ? AppColors.sageGreen : AppColors.emeraldGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            article.description,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 14),

          // Key Scientific Points
          if (article.keyPoints.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.biotech, size: 16, color: AppColors.emeraldGreen),
                const SizedBox(width: 6),
                Text(
                  'Key Scientific Findings',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.deepGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...article.keyPoints.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.sageGreen)),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
          ],

          // How You Can Help
          if (article.howToHelp.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.favorite, size: 16, color: AppColors.statusCR),
                const SizedBox(width: 6),
                Text(
                  'Actionable Conservation Steps',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.deepGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...article.howToHelp.map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check, size: 14, color: AppColors.success),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          step,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],

          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Source: ${article.source}',
              style: TextStyle(
                fontSize: 10.5,
                fontStyle: FontStyle.italic,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
