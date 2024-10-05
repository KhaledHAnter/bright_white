import 'package:bright_white/core/helpers/constants.dart';
import 'package:bright_white/core/routing/app_router.dart';
import 'package:bright_white/core/routing/routes.dart';
import 'package:bright_white/core/theming/colors.dart';
import 'package:flutter/material.dart';

class BrightWhite extends StatelessWidget {
  final AppRouter appRouter;
  const BrightWhite({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: LoginView(),
      debugShowCheckedModeBanner: false,
      title: "Doc Adavanced Flutter",
      theme: ThemeData(
        fontFamily: kFontFamily,
        primaryColor: ColorsManager.mainBlue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: Routes.authView,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
