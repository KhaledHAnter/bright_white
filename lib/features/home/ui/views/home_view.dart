import 'package:bright_white/core/helpers/extentions.dart';
import 'package:bright_white/core/routing/routes.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: IconButton(
              onPressed: () => context.pushNamed(Routes.authView),
              icon: const Icon(Icons.home))),
    );
  }
}
