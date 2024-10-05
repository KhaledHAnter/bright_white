import 'package:bright_white/core/helpers/assets.dart';
import 'package:bright_white/core/theming/colors.dart';
import 'package:bright_white/core/widgets/circle_logo.dart';
import 'package:bright_white/features/Auth/ui/views/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              // padding: const EdgeInsets.all(128),
              color: ColorsManager.mainGray,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Assets.imagesBanner3),
                      fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const CircleLogo(),
                const Gap(48),
                Padding(
                  padding: const EdgeInsets.only(left: 48, right: 100),
                  child: AuthForm(),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
