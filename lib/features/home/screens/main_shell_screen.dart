import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../widgets/app_logo_widget.dart';
import 'home_screen.dart';
import '../../explore/screens/explore_screen.dart';
import '../../favorites/screens/favorites_screen.dart';
import '../../learn/screens/learn_screen.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../providers/app_providers.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoriteCount = ref.watch(favoritesProvider).length;

    final screens = [
      const HomeScreen(),
      const ExploreScreen(),
      FavoritesScreen(onNavigateToExplore: () {
        setState(() => _currentIndex = 1);
      }),
      const LearnScreen(),
      const DashboardScreen(),
      const ProfileScreen(),
    ];

    if (isDesktop || isTablet) {
      // Large screen: NavigationRail + Expanded screen
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              labelType: NavigationRailLabelType.all,
              backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
              selectedIconTheme: const IconThemeData(color: AppColors.deepGreen),
              selectedLabelTextStyle: const TextStyle(
                color: AppColors.deepGreen,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: AppLogoWidget(size: 44),
              ),
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: Text('Explore'),
                ),
                NavigationRailDestination(
                  icon: Badge(
                    isLabelVisible: favoriteCount > 0,
                    label: Text(favoriteCount.toString()),
                    child: const Icon(Icons.favorite_border),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: favoriteCount > 0,
                    label: Text(favoriteCount.toString()),
                    child: const Icon(Icons.favorite),
                  ),
                  label: const Text('Saved'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book),
                  label: Text('Learn'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: Text('Dashboard'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Profile'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: screens[_currentIndex]),
          ],
        ),
      );
    }

    // Mobile: Bottom Navigation Bar
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: favoriteCount > 0,
              label: Text(favoriteCount.toString()),
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: Badge(
              isLabelVisible: favoriteCount > 0,
              label: Text(favoriteCount.toString()),
              child: const Icon(Icons.favorite),
            ),
            label: 'Saved',
          ),
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Learn',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Dashboard',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
