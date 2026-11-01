import 'package:flutter/material.dart';
import '../../features/home/screens/main_shell_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/species/screens/species_details_screen.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/register_screen.dart';
import '../../features/authentication/screens/forgot_password_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String speciesDetails = '/species-details';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const MainShellScreen());
      case speciesDetails:
        final speciesId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SpeciesDetailsScreen(speciesId: speciesId));
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
