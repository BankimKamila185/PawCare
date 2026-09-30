import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_header.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/pet_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/vaccination_card.dart';
import '../add_vaccination/add_vaccination_screen.dart';
import '../main_navigation_screen.dart';
import 'pet_vaccination_details_screen.dart';

class VaccinationTrackerScreen extends StatelessWidget {
  final VoidCallback onAdoptPetsTap;
  final VoidCallback onNotificationTap;
  final int notificationCount;

  const VaccinationTrackerScreen({
    super.key,
    required this.onAdoptPetsTap,
    required this.onNotificationTap,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    final petService = PetServiceHolder.of(context);
    final adoptedPets = petService.getAdoptedPets();

    final totalPets = petService.totalAdoptedPetsCount;
    final upToDateCount = petService.upToDateAdoptedPetsCount;
    final dueSoonCount = petService.dueSoonAdoptedPetsCount;
    final overdueCount = petService.overdueAdoptedPetsCount;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppHeader(
        title: 'Vaccines',
        notificationCount: notificationCount,
        onNotificationTap: onNotificationTap,
      ),
      body: adoptedPets.isEmpty
          ? EmptyStateView(
              icon: Icons.vaccines_rounded,
              title: 'No vaccination records yet',
              description: 'Adopt a pet to initialize and track their clinical immunization schedule.',
              buttonLabel: 'Browse Available Pets',
              onButtonPressed: onAdoptPetsTap,
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Keep your pets healthy and protected.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4-Grid Metric Summary Cards
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.45,
                    children: [
                      // Total Pets
                      MetricSummaryCard(
                        label: 'Total Pets',
                        count: totalPets,
                        badgeText: 'registered',
                        icon: Icons.pets_rounded,
                        iconColor: AppColors.primary,
                        badgeBgColor: AppColors.surfaceContainerHigh,
                        badgeFgColor: AppColors.onSurfaceVariant,
                      ),
                      // Up to Date
                      MetricSummaryCard(
                        label: 'Up to Date',
                        count: upToDateCount,
                        badgeText: 'Safe',
                        icon: Icons.check_circle_rounded,
                        iconColor: AppColors.secondary,
                        badgeBgColor: AppColors.secondaryFixed,
                        badgeFgColor: AppColors.onSecondaryFixedVariant,
                        showDot: true,
                        dotColor: AppColors.secondary,
                      ),
                      // Due Soon
                      MetricSummaryCard(
                        label: 'Due Soon',
                        count: dueSoonCount,
                        badgeText: dueSoonCount > 0 ? '$dueSoonCount alert' : 'None',
                        icon: Icons.schedule_rounded,
                        iconColor: AppColors.tertiary,
                        badgeBgColor: AppColors.tertiaryFixed,
                        badgeFgColor: AppColors.onTertiaryFixedVariant,
                      ),
                      // Overdue
                      MetricSummaryCard(
                        label: 'Overdue',
                        count: overdueCount,
                        badgeText: overdueCount > 0 ? '$overdueCount alert' : 'None',
                        icon: Icons.error_outline_rounded,
                        iconColor: overdueCount > 0 ? AppColors.error : AppColors.onSurfaceVariant,
                        badgeBgColor: overdueCount > 0
                            ? AppColors.errorContainer
                            : AppColors.surfaceContainerHigh,
                        badgeFgColor: overdueCount > 0
                            ? AppColors.onErrorContainer
                            : AppColors.onSurfaceVariant,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pet Health Cards',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        '$totalPets ${totalPets == 1 ? "record" : "records"} active',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Pet Health Cards
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: adoptedPets.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final pet = adoptedPets[index];
                      return MyPetCard(
                        pet: pet,
                        onViewVaccinations: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PetVaccinationDetailsScreen(petId: pet.id),
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Add New Vaccine Record CTA Button
                  PrimaryButton(
                    label: 'Add New Vaccine Record',
                    leadingIcon: Icons.add_rounded,
                    onPressed: () {
                      _showSelectPetForVaccination(context, adoptedPets);
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  void _showSelectPetForVaccination(BuildContext context, List<dynamic> pets) {
    if (pets.isEmpty) return;

    if (pets.length == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddVaccinationScreen(petId: pets.first.id),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AppColors.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Pet for Vaccination',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                ...pets.map((pet) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Image.network(
                        pet.image,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.pets, color: AppColors.primary),
                      ),
                    ),
                    title: Text(
                      pet.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text('${pet.breed} • ${pet.age}'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddVaccinationScreen(petId: pet.id),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
