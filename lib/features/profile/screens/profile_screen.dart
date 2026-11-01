import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../widgets/app_logo_widget.dart';
import '../../home/providers/app_providers.dart';
import '../../authentication/screens/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: const AppLogoWidget(size: 48),
      children: [
        const SizedBox(height: 12),
        const Text(
          'A real-world wildlife conservation and biodiversity information platform built with Flutter and Dart.',
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 10),
        const Text(
          'Scientific Data Sources:\n• Global Biodiversity Information Facility (GBIF)\n• International Union for Conservation of Nature (IUCN) Red List\n• Wikimedia Commons Photographic Archives',
          style: TextStyle(fontSize: 12, height: 1.4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final themeMode = ref.watch(themeModeProvider);
    final favoriteIds = ref.watch(favoritesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // User Profile Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.lightGreen,
                    child: Icon(
                      user != null && !user.isGuest ? Icons.person : Icons.pets,
                      size: 34,
                      color: AppColors.deepGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'Conservation Supporter',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? 'Guest Session',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: user != null && !user.isGuest
                                ? AppColors.emeraldGreen.withOpacity(0.15)
                                : Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            user != null && !user.isGuest ? 'Verified Conservationist' : 'Guest Explorer',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: user != null && !user.isGuest ? AppColors.emeraldGreen : Colors.orange.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (user == null || user.isGuest)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text('Sign In', style: TextStyle(fontSize: 12)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Activity Overview Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: ListTile(
              leading: const Icon(Icons.favorite, color: Colors.redAccent),
              title: const Text('Saved Species Collection'),
              subtitle: Text(
                user != null && !user.isGuest
                    ? 'Synced with your Cloud account'
                    : 'Saved locally on this device',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${favoriteIds.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepGreen,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Theme Settings
          Text(
            'Appearance & Display',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.deepGreen,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('System Default'),
                  subtitle: const Text('Follow system theme setting', style: TextStyle(fontSize: 12)),
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  activeColor: AppColors.emeraldGreen,
                  onChanged: (mode) {
                    if (mode != null) {
                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                    }
                  },
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: const Text('Light Mode'),
                  subtitle: const Text('Clean nature green palette', style: TextStyle(fontSize: 12)),
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  activeColor: AppColors.emeraldGreen,
                  onChanged: (mode) {
                    if (mode != null) {
                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                    }
                  },
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Deep emerald night mode', style: TextStyle(fontSize: 12)),
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  activeColor: AppColors.emeraldGreen,
                  onChanged: (mode) {
                    if (mode != null) {
                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Information & Support
          Text(
            'Information & Integrity',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.deepGreen,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: AppColors.sageGreen),
                  title: const Text('About This Platform'),
                  subtitle: const Text('Version 1.0.0 • Mission and data integrity', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () => _showAboutDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.verified_outlined, color: AppColors.sageGreen),
                  title: const Text('Data Accuracy Policy'),
                  subtitle: const Text('Never fabricated • GBIF & IUCN Red List verified', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Data Integrity Commitment'),
                        content: const Text(
                          'Endangered Species Gallery is dedicated to authentic biological facts.\n\n'
                          '• Occurrence counts are sourced via GBIF and explicitly distinguished from wild population numbers.\n'
                          '• All conservation risk statuses follow official IUCN Red List assessments.\n'
                          '• Images are legally licensed under Creative Commons or Public Domain from Wikimedia Commons.',
                          style: TextStyle(fontSize: 13, height: 1.45),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('I Understand'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout / Account Switch
          if (user != null && !user.isGuest)
            OutlinedButton.icon(
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () async {
                await ref.read(authProvider.notifier).signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed out successfully.')),
                  );
                }
              },
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
