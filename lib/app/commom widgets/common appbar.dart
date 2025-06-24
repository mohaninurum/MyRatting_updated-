import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget {
  final Widget? rightWidget; // This will be an optional widget for the right side

  const CommonAppBar({super.key, this.rightWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/logo.png",
              height: 30,
              color: AppColors.primaryColor,
            ),
          ),
          Text(
            "My Rating App",
            style: AppFonts.IBMPlexSans.copyWith(fontSize: 25, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),
          Spacer(),
          // Conditionally display the rightWidget if provided
          if (rightWidget != null) rightWidget!,
        ],
      ),
    );
  }
}
