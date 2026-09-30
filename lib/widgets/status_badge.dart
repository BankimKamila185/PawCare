import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final VaccinationStatus status;
  final bool showIcon;

  const StatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    Color dotColor;
    String label;

    switch (status) {
      case VaccinationStatus.upToDate:
        bgColor = AppColors.secondaryContainer;
        fgColor = AppColors.onSecondaryContainer;
        dotColor = AppColors.secondary;
        label = 'Up to Date';
        break;
      case VaccinationStatus.dueSoon:
        bgColor = AppColors.tertiaryFixed;
        fgColor = AppColors.onTertiaryFixedVariant;
        dotColor = AppColors.tertiary;
        label = 'Due Soon';
        break;
      case VaccinationStatus.overdue:
        bgColor = AppColors.errorContainer;
        fgColor = AppColors.onErrorContainer;
        dotColor = AppColors.error;
        label = 'Overdue';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: fgColor,
              letterSpacing: 0.02,
            ),
          ),
        ],
      ),
    );
  }
}

class AvailabilityBadge extends StatelessWidget {
  final AdoptionStatus status;

  const AvailabilityBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    Color dotColor;
    String label;

    switch (status) {
      case AdoptionStatus.available:
        bgColor = AppColors.secondaryFixed;
        fgColor = AppColors.onSecondaryFixedVariant;
        dotColor = AppColors.secondary;
        label = 'Available';
        break;
      case AdoptionStatus.adopted:
        bgColor = AppColors.primaryFixed;
        fgColor = AppColors.onPrimaryFixedVariant;
        dotColor = AppColors.primary;
        label = 'Adopted';
        break;
      case AdoptionStatus.pending:
        bgColor = AppColors.tertiaryFixed;
        fgColor = AppColors.onTertiaryFixedVariant;
        dotColor = AppColors.tertiary;
        label = 'Pending';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}
