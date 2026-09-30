import 'package:flutter/material.dart';
import '../../models/enums.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/status_badge.dart';
import '../main_navigation_screen.dart';
import '../vaccinations/pet_vaccination_details_screen.dart';

class VaccinationRemindersScreen extends StatelessWidget {
  const VaccinationRemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final petService = PetServiceHolder.of(context);
    final reminders = petService.getActiveReminders();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Vaccination Reminders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: reminders.isEmpty
          ? const EmptyStateView(
              icon: Icons.notifications_off_outlined,
              title: 'All caught up!',
              description: 'No pending or overdue vaccinations for your adopted pets. Great job keeping them healthy!',
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.alarm_on_rounded, color: AppColors.primary, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'On-Device Clinical Alerts',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onPrimaryFixed,
                                ),
                              ),
                              Text(
                                'Calculated in real-time from target vaccination due dates.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onPrimaryFixedVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Active Alerts (${reminders.length})',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reminders.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = reminders[index];
                      final isOverdue = item.status == VaccinationStatus.overdue;

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isOverdue
                                ? AppColors.error.withValues(alpha: 0.3)
                                : AppColors.tertiary.withValues(alpha: 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isOverdue
                                        ? AppColors.errorContainer
                                        : AppColors.tertiaryFixed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isOverdue
                                        ? Icons.error_rounded
                                        : Icons.notifications_active_rounded,
                                    color: isOverdue ? AppColors.error : AppColors.tertiary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: isOverdue ? AppColors.error : AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.subtitle,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                StatusBadge(status: item.status),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                  ),
                                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                                  label: const Text(
                                    'Open Vaccine Record',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PetVaccinationDetailsScreen(petId: item.pet.id),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
