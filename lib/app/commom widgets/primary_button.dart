import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/appColors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.borderRadius = 100.0,
    this.height = 52.0,
    required this.btnColor,
    this.borderColor = AppColors.primaryColor,
    this.textColor,
    this.borderWidth = 1.0,
    required this.onPressed,
    required this.title,
    required this.hasIcon,
    this.iconWidget,
    this.hasIconRight = false,
    this.isLoading = false, // New loading parameter
  });

  final double borderRadius;
  final double height;
  final Color? btnColor;
  final Color? borderColor;
  final Color? textColor;
  final double borderWidth;
  final VoidCallback? onPressed;
  final String title;
  final bool hasIcon;
  final bool hasIconRight;
  final Widget? iconWidget;
  final bool isLoading; // New

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? Theme.of(context).colorScheme.primary,
            width: borderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: btnColor ?? Theme.of(context).colorScheme.primary,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CupertinoActivityIndicator(
          color: Colors.white,
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasIcon) ...[
              if (hasIconRight) ...[
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(color: textColor ?? Colors.grey,fontSize: 18),
                  ),
                ),
                const SizedBox(width: 7),
                iconWidget ?? const SizedBox.shrink(),
              ] else ...[
                iconWidget ?? const SizedBox.shrink(),
                const SizedBox(width: 7),
                Text(
                  title,
                  style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(color: textColor ?? Colors.grey,fontSize: 18),
                ),
              ]
            ] else ...[
              Text(
                title,
                style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(color: textColor ?? Colors.grey,fontSize: 18),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
