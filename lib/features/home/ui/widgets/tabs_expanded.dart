import 'package:bright_white/core/theming/colors.dart';
import 'package:bright_white/core/theming/styles.dart';
import 'package:bright_white/core/widgets/circle_logo.dart';
import 'package:bright_white/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TabsExpanded extends StatelessWidget {
  const TabsExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      color: const Color(0xFFFCF7F7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleLogo(),
          const Divider(
            height: 20,
            indent: 50,
            endIndent: 50,
            thickness: 1,
            color: ColorsManager.mainRed,
          ),
          const Gap(80),
          Row(
            children: <Widget>[
              const CircleAvatar(
                radius: 5,
                backgroundColor: ColorsManager.mainRed,
              ),
              const Gap(12),
              Text(
                S.of(context).home_tab1,
                style: Styles.bold24,
              ),
            ],
          ),
          const Gap(24),
          Row(
            children: <Widget>[
              const Gap(22),
              Text(
                S.of(context).home_tab2,
                style: Styles.bold24,
              ),
            ],
          ),
          const Gap(24),
          Row(
            children: <Widget>[
              const Gap(22),
              Text(
                S.of(context).home_tab3,
                style: Styles.bold24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
