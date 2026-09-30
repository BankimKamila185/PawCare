import 'package:flutter/material.dart';
import '../../models/enums.dart';
import '../../theme/app_theme.dart';
import '../../utils/vaccination_utils.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/vaccination_card.dart';
import '../add_vaccination/add_vaccination_screen.dart';
import '../main_navigation_screen.dart';

class PetVaccinationDetailsScreen extends StatelessWidget {
  final String petId;

  const PetVaccinationDetailsScreen({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    final petService = PetServiceHolder.of(context);
    final pet = petService.getPetById(petId);

    if (pet == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Vaccination Details')),
        body: const Center(child: Text('Pet not found.')),
      );
    }

    final overallStatus = VaccinationUtils.calculateOverallPetStatus(pet);
    final nextVac = VaccinationUtils.getNextUpcomingVaccination(pet);
    final daysRemaining = nextVac != null
        ? VaccinationUtils.calculateDaysRemaining(nextVac.nextDueDate)
        : 0;
    final nextStatus = nextVac != null
        ? VaccinationUtils.calculateVaccinationStatus(nextVac.nextDueDate)
        : VaccinationStatus.upToDate;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('${pet.name} Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Pet Profile Header Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: Image.network(
                                    pet.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.pets, size: 36),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -2,
                                right: -2,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: const BoxDecoration(
                                    color: AppColors.secondaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.pets_rounded,
                                      size: 13,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      pet.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryFixed,
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        pet.category == PetCategory.cats ? 'Feline' : 'Canine',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.onPrimaryFixed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${pet.breed} • ${pet.age}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Overall status banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: overallStatus == VaccinationStatus.overdue
                              ? AppColors.errorContainer
                              : overallStatus == VaccinationStatus.dueSoon
                                  ? AppColors.tertiaryFixed.withValues(alpha: 0.7)
                                  : AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: overallStatus == VaccinationStatus.overdue
                                        ? AppColors.error
                                        : overallStatus == VaccinationStatus.dueSoon
                                            ? AppColors.tertiary
                                            : AppColors.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  overallStatus == VaccinationStatus.overdue
                                      ? 'Overdue • Action Needed'
                                      : overallStatus == VaccinationStatus.dueSoon
                                          ? 'Due Soon • Booster Upcoming'
                                          : 'Protected • Up to Date',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: overallStatus == VaccinationStatus.overdue
                                        ? AppColors.onErrorContainer
                                        : overallStatus == VaccinationStatus.dueSoon
                                            ? AppColors.onTertiaryFixedVariant
                                            : AppColors.onSecondaryContainer,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              overallStatus == VaccinationStatus.overdue
                                  ? Icons.warning_rounded
                                  : overallStatus == VaccinationStatus.dueSoon
                                      ? Icons.notification_important_rounded
                                      : Icons.check_circle_rounded,
                              size: 18,
                              color: overallStatus == VaccinationStatus.overdue
                                  ? AppColors.error
                                  : overallStatus == VaccinationStatus.dueSoon
                                      ? AppColors.tertiary
                                      : AppColors.secondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Next Vaccination Hero Card
                if (nextVac != null)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: nextStatus == VaccinationStatus.overdue
                            ? [
                                AppColors.errorContainer,
                                AppColors.surfaceContainerLowest,
                              ]
                            : [
                                AppColors.primaryFixed,
                                AppColors.surfaceContainerLowest,
                              ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  nextStatus == VaccinationStatus.overdue
                                      ? Icons.warning_amber_rounded
                                      : Icons.verified_rounded,
                                  color: nextStatus == VaccinationStatus.overdue
                                      ? AppColors.error
                                      : AppColors.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'NEXT VACCINATION',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                    color: nextStatus == VaccinationStatus.overdue
                                        ? AppColors.error
                                        : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    nextStatus == VaccinationStatus.overdue
                                        ? Icons.error_outline_rounded
                                        : Icons.hourglass_top_rounded,
                                    size: 13,
                                    color: nextStatus == VaccinationStatus.overdue
                                        ? AppColors.error
                                        : AppColors.tertiary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    nextStatus == VaccinationStatus.overdue
                                        ? '${daysRemaining.abs()} days overdue'
                                        : '$daysRemaining days remaining',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: nextStatus == VaccinationStatus.overdue
                                          ? AppColors.error
                                          : AppColors.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              nextVac.vaccineName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                              ),
                            ),
                            StatusBadge(status: nextStatus),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.event_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              VaccinationUtils.formatDate(nextVac.nextDueDate),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // 3. Vaccination Timeline Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'VACCINATION HISTORY & TIMELINE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.outline,
                      ),
                    ),
                    Text(
                      '${pet.vaccinations.length} Records',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Timeline List
                if (pet.vaccinations.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'No vaccination records added yet.',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pet.vaccinations.length,
                    itemBuilder: (context, index) {
                      final vac = pet.vaccinations[index];
                      return VaccinationTimelineCard(
                        vaccination: vac,
                        isLast: index == pet.vaccinations.length - 1,
                      );
                    },
                  ),
              ],
            ),
          ),

          // Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.95),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: PrimaryButton(
                  label: 'Add Vaccination',
                  leadingIcon: Icons.add_rounded,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddVaccinationScreen(petId: pet.id),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
