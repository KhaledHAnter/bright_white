import 'package:bright_white/core/theming/colors.dart';
import 'package:bright_white/core/theming/styles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const AppButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
            color: ColorsManager.blue, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            text,
            style: Styles.semiBold18.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
