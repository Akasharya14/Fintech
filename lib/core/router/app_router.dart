import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/splash_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/forgot_password_screen.dart';
import '../../screens/otp_screen.dart';

import '../../screens/onboarding_screen.dart';
import '../../screens/profile_screen.dart';
import '../controller/auth_controller.dart';

class AppRouteNames {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';
  static const String otp = 'otp';
  static const String resetPassword = 'reset-password';
  static const String dashboard = 'dashboard';
  static const String profile = 'profile';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: Get.key,
    initialLocation: '/splash',
    refreshListenable: AuthController.to.authChangeNotifier,
    redirect: (context, state) {
      final isLoggedIn = AuthController.to.isLoggedIn;
      
      // Public routes list
      final publicRoutes = [
        '/splash',
        '/onboarding',
        '/login',
        '/register',
        '/forgot-password',
        '/otp',
        '/reset-password',
      ];

      final isPublicRoute = publicRoutes.contains(state.matchedLocation);

      // 1. If not logged in and trying to access a private route -> Redirect to Login
      if (!isLoggedIn && !isPublicRoute) {
        return '/login';
      }

      // 2. If logged in and on Auth screens -> Redirect to Dashboard
      final authScreens = ['/login', '/register', '/onboarding'];
      if (isLoggedIn && authScreens.contains(state.matchedLocation)) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: AppRouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: AppRouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: AppRouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: AppRouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: AppRouteNames.otp,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: AppRouteNames.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: AppRouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
