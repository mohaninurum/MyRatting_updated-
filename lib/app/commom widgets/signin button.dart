import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:flutter/material.dart';
class SignInCommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final double paddingVertical;
  final double paddingHorizontal;
  final double fontSize;
  final IconData? icon;
  final double iconSize;
  final Color? iconColor;
  final Widget? prefixIcon;

  const SignInCommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.borderRadius = 8.0,
    this.paddingVertical = 12.0,
    this.paddingHorizontal = 16.0,
    this.fontSize = 16.0,
    this.icon,
    this.iconSize = 24.0,
    this.iconColor,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical,
          horizontal: paddingHorizontal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null) ...[
            prefixIcon!,
            const SizedBox(width: 8),
          ],
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: iconColor),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: textStyle ??
                AppFonts.IBMPlexSans.copyWith(
                  fontSize: fontSize,
                  color: textColor ?? AppColors.white,
                ),
          ),
        ],
      ),
    );
  }
}


