import 'package:flutter/material.dart';
import 'package:mobile_lapalapa/screen/onboarding/onboarding_screen.dart';
import 'package:mobile_lapalapa/screen/suggestion/suggestion_screen.dart';

import '../screen/main_screen.dart';
import '../screen/splash_screen.dart';
import '../screen/trading/detail_trading/detail_trading_screen.dart';

class Routes {
  static const String root = '/';
  static const String onBoarding = '/on_boarding';
  static const String mainScreen = '/main_screen';
  static const String detailTrading = '/detail_trading';
  static const String suggestion = '/suggestion';
}

class AppRoute {
  static Route<dynamic>? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case Routes.root:
        return MaterialPageRoute(
            settings: setting, builder: ((context) => const SplashScreen()));
      case Routes.onBoarding:
        return MaterialPageRoute(
            settings: setting,
            builder: ((context) => const OnboardingScreen()));
      case Routes.mainScreen:
        return PageRouteBuilder(
            settings: setting,
            pageBuilder: ((context, animation, secondaryAnimation) =>
                MainScreen(
                  index: setting.arguments as int? ?? 0,
                )),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end);
              final offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            });
      case Routes.detailTrading:
        return MaterialPageRoute(
            settings: setting,
            builder: ((context) =>
                DetailTradingScreen(id: (setting.arguments as String))));

      case Routes.suggestion:
        return MaterialPageRoute(
            settings: setting,
            builder: ((context) => const SuggestionScreen()));

      default:
        return null;
    }
  }
}
