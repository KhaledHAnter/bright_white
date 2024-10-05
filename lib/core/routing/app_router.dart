import 'package:bright_white/core/routing/routes.dart';
import 'package:bright_white/features/Auth/ui/views/auth_view.dart';
import 'package:bright_white/features/home/ui/views/home_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    // this arguments to be passed in any screen like this (arguments: arguments as ClassName)
    final arrguments = settings.arguments;

    switch (settings.name) {
      case Routes.authView:
        return MaterialPageRoute(
          builder: (_) => const AuthView(),
        );
      case Routes.homeView:
        return MaterialPageRoute(
          builder: (_) => const HomeView(),
        );

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text("No route defined for ${settings.name}"),
                  ),
                ));
    }
  }
}
