import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/main_shell.dart';
import '../screens/home/home_screen.dart';
import '../screens/learn/learn_screen.dart';
import '../screens/reflect/reflect_screen.dart';
import '../screens/journeys/journeys_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/faith_score/faith_score_screen.dart';
import '../screens/memorize/memorize_screen.dart';
import '../screens/quran/surah_list_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/learn',
            builder: (context, state) => const LearnScreen(),
            routes: [
              GoRoute(
                path: 'surah/:number',
                builder: (context, state) {
                  final num = int.tryParse(
                        state.pathParameters['number'] ?? '1',
                      ) ??
                      1;
                  return LearnScreen(initialSurahNumber: num);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/reflect',
            builder: (context, state) => const ReflectScreen(),
          ),
          GoRoute(
            path: '/journeys',
            builder: (context, state) => const JourneysScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/faith-score',
            builder: (context, state) => const FaithScoreScreen(),
          ),
          GoRoute(
            path: '/memorize',
            builder: (context, state) => const MemorizeScreen(),
          ),
          GoRoute(
            path: '/quran',
            builder: (context, state) => const SurahListScreen(),
          ),
        ],
      ),
    ],
  );
});
