import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../models/vaccination.dart';
import '../theme/app_theme.dart';
import '../utils/vaccination_utils.dart';

class MetricSummaryCard extends StatelessWidget {
  final String label;
  final int count;
  final String badgeText;
  final IconData icon;
  final Color iconColor;
  final Color badgeBgColor;
  final Color badgeFgColor;
  final bool showDot;
  final Color? dotColor;

  const MetricSummaryCard({
    super.key,
    required this.label,
    required this.count,
    required this.badgeText,
    required this.icon,
    required this.iconColor,
    required this.badgeBgColor,
    required this.badgeFgColor,
    this.showDot = false,
    this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Icon(icon, size: 20, color: iconColor),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showDot && dotColor != null) ...[
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: badgeFgColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VaccinationTimelineCard extends StatelessWidget {
  final Vaccination vaccination;
  final bool isLast;

  const VaccinationTimelineCard({
    super.key,
    required this.vaccination,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = VaccinationUtils.calculateVaccinationStatus(vaccination.nextDueDate);

    Color nodeBgColor;
    Color nodeFgColor;
    IconData nodeIcon;
    String badgeLabel;
    Color badgeBg;
    Color badgeFg;

    switch (status) {
      case VaccinationStatus.upToDate:
        nodeBgColor = AppColors.secondaryContainer;
        nodeFgColor = AppColors.secondary;
        nodeIcon = Icons.check_rounded;
        badgeLabel = vaccination.category.isNotEmpty ? vaccination.category : 'Completed';
        badgeBg = AppColors.secondaryContainer;
        badgeFg = AppColors.onSecondaryContainer;
        break;
      case VaccinationStatus.dueSoon:
        nodeBgColor = AppColors.tertiaryFixed;
        nodeFgColor = AppColors.tertiary;
        nodeIcon = Icons.schedule_rounded;
        badgeLabel = 'Upcoming (Due Soon)';
        badgeBg = AppColors.tertiaryFixed;
        badgeFg = AppColors.onTertiaryFixedVariant;
        break;
      case VaccinationStatus.overdue:
        nodeBgColor = AppColors.errorContainer;
        nodeFgColor = AppColors.error;
        nodeIcon = Icons.warning_rounded;
        badgeLabel = 'Overdue';
        badgeBg = AppColors.errorContainer;
        badgeFg = AppColors.onErrorContainer;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Node & Rail
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: nodeBgColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(nodeIcon, size: 18, color: nodeFgColor),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.surfaceContainerHigh,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 14),

          // Content Card
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          vaccination.vaccineName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badgeLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: badgeFg,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (vaccination.notes.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      vaccination.notes,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 14,
                        color: status == VaccinationStatus.overdue
                            ? AppColors.error
                            : AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Administered: ${VaccinationUtils.formatDate(vaccination.dateGiven, short: true)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Next Due: ${VaccinationUtils.formatDate(vaccination.nextDueDate, short: true)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: status == VaccinationStatus.overdue
                              ? AppColors.error
                              : status == VaccinationStatus.dueSoon
                                  ? AppColors.tertiary
                                  : AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
