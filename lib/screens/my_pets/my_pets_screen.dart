import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_header.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/pet_card.dart';
import '../main_navigation_screen.dart';
import '../vaccinations/pet_vaccination_details_screen.dart';

class MyPetsScreen extends StatelessWidget {
  final VoidCallback onExplorePets;
  final VoidCallback onNotificationTap;
  final int notificationCount;

  const MyPetsScreen({
    super.key,
    required this.onExplorePets,
    required this.onNotificationTap,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    final petService = PetServiceHolder.of(context);
    final adoptedPets = petService.getAdoptedPets();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppHeader(
        title: 'My Pets',
        notificationCount: notificationCount,
        onNotificationTap: onNotificationTap,
      ),
      body: adoptedPets.isEmpty
          ? EmptyStateView(
              icon: Icons.cruelty_free_rounded,
              title: 'No pets yet',
              description: 'Adopt a loving companion and start their care journey with automated vaccination tracking.',
              buttonLabel: 'Browse Available Pets',
              onButtonPressed: onExplorePets,
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Adopted Companions',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${adoptedPets.length} ${adoptedPets.length == 1 ? "pet" : "pets"} under your loving care',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: onExplorePets,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded, size: 16, color: AppColors.primary),
                              SizedBox(width: 4),
                              Text(
                                'Adopt More',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onPrimaryFixedVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // List of Adopted Pets
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
