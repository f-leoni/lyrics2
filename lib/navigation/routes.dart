import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyrics2/constants.dart';

import '../data/sqlite_settings_repository.dart';
import '../models/app_state_manager.dart';
import '../screens/main_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/profile_screen.dart';

class MyRouter {
  final SQLiteSettingsRepository settingsRepository;
  final AppStateManager appStateManager;

  bool _isOnboardingComplete = false;

  MyRouter(this.appStateManager, this.settingsRepository);

  late final router = GoRouter(
      refreshListenable: appStateManager,
      //TODO: remove before release
      debugLogDiagnostics: true,
      urlPathStrategy: UrlPathStrategy.path,
      routes: [
        GoRoute(
          name: rootRouteName,
          path: '/',
          redirect: (state) =>
              // Change to Home Route (Main page)
              state.namedLocation(rootRouteName,
                  params: {'tab': appStateManager.getSelectedTab.toString()}),
        ),
        GoRoute(
          name: onboardingRouteName,
          path: '/onboarding',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const OnboardingScreen(),
          ),
        ),
        GoRoute(
          name: rootRouteName,
          path: '/home/:tab/:search',
          pageBuilder: (context, state) {
            final tab = state.params['tab']!;
            final search = state.params['search']!;
            return MaterialPage<void>(
              key: state.pageKey,
              child: MainScreen(currentTab: int.parse(tab), search: search),
            );
          },
          routes: [
            GoRoute(
              name: settingsRouteName,
              path: '/settings',
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: const ProfileScreen(),
              ),
            ),
          ],
        ),
      ],
      /*errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),*/
      redirect: (state) {
        final onboardingLoc = state.namedLocation(onboardingRouteName);
        final isOnboarding = state.location == onboardingLoc;
        appStateManager.checkOnboarding(settingsRepository).then((value) {
          _isOnboardingComplete = value;
        });
        final rootLoc = state.namedLocation(rootRouteName);
        //if trying to access any page when still not onboarded
        if (!_isOnboardingComplete) return onboardingLoc;
        // If trying to access onboarding while already onboarded
        if (_isOnboardingComplete && isOnboarding) return rootLoc;
        return null;
      });
}
