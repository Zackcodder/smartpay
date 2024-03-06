import 'package:flutter/material.dart';
import 'package:smartpay/core/extension/build_context_extensions.dart';

import '../core/constant/colors.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({super.key, required this.onPressed, required this.text});
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStatePropertyAll(
          AppColors.yellow.withOpacity(0.4),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: context.textTheme.bodySmall!.copyWith(
          color: AppColors.landingSubtextColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'SFPRODISPLAYBOLD'
        ),
      ),
    );
  }
}
