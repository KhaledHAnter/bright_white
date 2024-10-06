import 'package:bright_white/core/helpers/constants.dart';
import 'package:bright_white/core/routing/app_router.dart';
import 'package:bright_white/core/routing/routes.dart';
import 'package:bright_white/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

class BrightWhite extends StatelessWidget {
  final AppRouter appRouter;
  const BrightWhite({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
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
