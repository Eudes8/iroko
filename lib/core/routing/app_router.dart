import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iroko/presentation/auth/login_screen.dart';
import 'package:iroko/presentation/auth/register_screen.dart';
import 'package:iroko/presentation/home/home_screen.dart';
import 'package:iroko/presentation/profile/provider_profile_screen.dart';
import 'package:iroko/presentation/widgets/booking_screen.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    // Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    
    // Main Routes
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProviderProfileScreen(),
    ),
    GoRoute(
      path: '/booking/:missionId',
      name: 'booking',
      builder: (context, state) {
        final missionId = state.pathParameters['missionId'] ?? '';
        return BookingScreen(missionId: missionId);
      },
    ),
  ],
  
  // Error handling
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page non trouvée')),
      body: Center(
        child: Text('Erreur: ${state.error}'),
      ),
    );
  },
  
  // Redirect logic
  redirect: (context, state) {
    // Add authentication check if needed
    return null;
  },
);
