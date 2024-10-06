import 'package:bright_white/features/home/ui/widgets/tabs_expanded.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            // the tabs will be here
            Expanded(
              flex: 2,
              child: TabsExpanded(),
            ),
            Expanded(
              flex: 8,
              child: HomeViewBody(),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [],
    );
  }
}
