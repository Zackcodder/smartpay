import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartpay/core/constant/colors.dart';
import 'package:smartpay/core/extension/build_context_extensions.dart';

import 'spacing.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
  })  : _size = const Size(92, 36),
        isLarge = false,
        icon = null;

  const AppElevatedButton.large({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
  })  : _size = const Size(350, 60),
        isLarge = true;

  const AppElevatedButton.tiny({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
  })  : _size = const Size(50, 30),
        isLarge = true,
        icon = null;

  final VoidCallback onPressed;
  final String text;
  final Size _size;
  final bool isLarge;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          minimumSize: Size(_size.width.w, _size.height.h),
          textStyle: isLarge
              ? context.textTheme.bodyMedium!.copyWith(color: textColor)
              : context.textTheme.bodySmall!.copyWith(color: textColor),
        ),
        onPressed: onPressed,
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'SFPRODISPLAY',
                    color: AppColors.white),
              ),
              if (icon != null) ...[
                const HorizontalSpacing(5),
                Icon(icon),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
