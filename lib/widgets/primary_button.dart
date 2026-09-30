import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ButtonVariant {
  primary,
  secondaryTonal,
  outlined,
  danger,
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final ButtonVariant variant;
  final bool isLoading;
  final double height;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.height = 52,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case ButtonVariant.primary:
        bgColor = AppColors.primary;
        fgColor = AppColors.onPrimary;
        break;
      case ButtonVariant.secondaryTonal:
        bgColor = AppColors.primaryFixed;
        fgColor = AppColors.onPrimaryFixedVariant;
        break;
      case ButtonVariant.outlined:
        bgColor = Colors.transparent;
        fgColor = AppColors.onSurface;
        borderSide = const BorderSide(color: AppColors.outlineVariant, width: 1.5);
        break;
      case ButtonVariant.danger:
        bgColor = AppColors.errorContainer;
        fgColor = AppColors.onErrorContainer;
        break;
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 20, color: fgColor),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: fgColor,
            letterSpacing: 0.01,
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: 20, color: fgColor),
        ],
      ],
    );

    if (isLoading) {
      content = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: variant == ButtonVariant.primary ? 2 : 0,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          shape: StadiumBorder(side: borderSide),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        onPressed: isLoading ? null : onPressed,
        child: content,
      ),
    );
  }
}
