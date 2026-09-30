import 'package:flutter/material.dart';
import '../../models/enums.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_header.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/pet_card.dart';
import '../main_navigation_screen.dart';
import '../pet_profile/pet_profile_screen.dart';
import '../shelter/shelter_add_pet_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigateToTab;
  final VoidCallback onNotificationTap;
  final int notificationCount;

  const HomeScreen({
    super.key,
    required this.onNavigateToTab,
    required this.onNotificationTap,
    required this.notificationCount,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  PetCategory _selectedCategory = PetCategory.all;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petService = PetServiceHolder.of(context);
    final availablePets = petService.getAvailablePets(
      category: _selectedCategory,
      query: _searchQuery,
    );

    final allCount = petService.getAvailablePets(category: PetCategory.all).length;
    final dogsCount = petService.getAvailablePets(category: PetCategory.dogs).length;
    final catsCount = petService.getAvailablePets(category: PetCategory.cats).length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppHeader(
        title: 'Home',
        notificationCount: widget.notificationCount,
        onNotificationTap: widget.onNotificationTap,
        onProfileTap: () => widget.onNavigateToTab(3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rescue & Adopt Badge + Greeting
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.volunteer_activism_rounded,
                    size: 14,
                    color: AppColors.onPrimaryFixed,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Rescue & Adopt',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimaryFixed,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find Your New Best Friend',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Give a loving pet a forever home.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar & Shelter FAB
            CustomSearchBar(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              onFilterTap: () {
                _showShelterActionSheet(context);
              },
            ),
            const SizedBox(height: 14),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _buildCategoryChip(PetCategory.all, 'All ($allCount)'),
                  const SizedBox(width: 8),
                  _buildCategoryChip(PetCategory.dogs, 'Dogs ($dogsCount)'),
                  const SizedBox(width: 8),
                  _buildCategoryChip(PetCategory.cats, 'Cats ($catsCount)'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section Title with Shelter Shortcut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Pets (${availablePets.length})',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ShelterAddPetScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded, size: 14, color: AppColors.primary),
                        SizedBox(width: 2),
                        Text(
                          'Add Pet (Shelter)',
                          style: TextStyle(
                            fontSize: 11,
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
            const SizedBox(height: 12),

            // Pet Grid or Empty State
            if (availablePets.isEmpty)
              EmptyStateView(
                icon: Icons.search_off_rounded,
                title: 'No pets found',
                description: _searchQuery.isNotEmpty
                    ? 'No available pets match "$_searchQuery". Try searching for another name or breed.'
                    : 'All pets in this category have been adopted or are not currently available.',
                buttonLabel: 'Clear Filter',
                onButtonPressed: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                    _selectedCategory = PetCategory.all;
                  });
                },
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: availablePets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.58,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final pet = availablePets[index];
                  return PetDiscoveryCard(
                    pet: pet,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PetProfileScreen(petId: pet.id),
                        ),
                      );
                    },
                    onFavoriteToggle: () {
                      petService.toggleFavorite(pet.id);
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

  Widget _buildCategoryChip(PetCategory category, String label) {
    final isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(
                Icons.check_rounded,
                size: 16,
                color: AppColors.onPrimary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShelterActionSheet(BuildContext context) {
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
                  'Shelter & Filter Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add_home_rounded, color: AppColors.primary),
                  ),
                  title: const Text('Add Pet for Adoption'),
                  subtitle: const Text('Shelter intake: list a new pet profile'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ShelterAddPetScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.restart_alt_rounded, color: AppColors.onSurface),
                  ),
                  title: const Text('Reset Sample Pets'),
                  subtitle: const Text('Reload Bruno, Luna, Max, Bella'),
                  onTap: () {
                    final petService = PetServiceHolder.of(context);
                    petService.resetToSeedData();
                    Navigator.of(sheetContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reset to initial sample pets.')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
