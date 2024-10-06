import 'package:flutter/material.dart';
import 'package:bright_white/core/theming/colors.dart';
import 'package:bright_white/core/theming/styles.dart';
import 'package:bright_white/generated/l10n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).home_lbl,
            style: Styles.bold32.copyWith(color: Colors.black),
          ),
          const Gap(48),
          SizedBox(
            width: (MediaQuery.sizeOf(context).width / 3) / 2,
            child: TextField(
              style: Styles.bold16,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xff747474),
                ),
                hintText: S.of(context).home_search,
                hintStyle: const TextStyle(color: Color(0xff747474)),
                fillColor: const Color(0xffEFEFEF),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const Gap(48),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xffEFEFEF),
            ),
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Set border radius to 12
                    ),
                    backgroundColor: ColorsManager.mainRed,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    S.of(context).home_newEntry,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  S.of(context).home_total("2,000"),
                  style: Styles.semiBold16.copyWith(color: Colors.black),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  S.of(context).home_name,
                  style: Styles.bold20,
                ),
                const Spacer(),
                Text(
                  S.of(context).home_phoneNum,
                  style: Styles.bold20,
                ),
                const Spacer(),
                Text(
                  S.of(context).home_money,
                  style: Styles.bold20,
                ),
                const Spacer(
                  flex: 2,
                ),
                Text(
                  S.of(context).home_actions,
                  style: Styles.bold20,
                ),
                // const Spacer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  "احمد عنتر",
                  style: Styles.semiBold18,
                ),
                const Spacer(),
                Text(
                  "01012343087",
                  style: Styles.semiBold18,
                ),
                const Spacer(),
                Text(
                  "2,000",
                  style: Styles.semiBold18,
                ),
                const Spacer(
                  flex: 2,
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.list),
                    ),
                    const Gap(16),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.plusMinus),
                    ),
                    const Gap(16),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.whatsapp),
                    ),
                    const Gap(16),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.trashCan,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                // const Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
