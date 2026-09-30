import 'package:flutter/material.dart';
import '../services/pet_service.dart';
import '../theme/app_theme.dart';
import 'home/home_screen.dart';
import 'my_pets/my_pets_screen.dart';
import 'profile/profile_screen.dart';
import 'reminders/vaccination_reminders_screen.dart';
import 'vaccinations/vaccination_tracker_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final petService = PetServiceHolder.of(context);
    final activeReminders = petService.getActiveReminders();

    final screens = [
      HomeScreen(
        onNavigateToTab: _onTabTapped,
        onNotificationTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const VaccinationRemindersScreen(),
            ),
          );
        },
        notificationCount: activeReminders.length,
      ),
      MyPetsScreen(
        onExplorePets: () => _onTabTapped(0),
        onNotificationTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const VaccinationRemindersScreen(),
            ),
          );
        },
        notificationCount: activeReminders.length,
      ),
      VaccinationTrackerScreen(
        onAdoptPetsTap: () => _onTabTapped(0),
        onNotificationTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const VaccinationRemindersScreen(),
            ),
          );
        },
        notificationCount: activeReminders.length,
      ),
      ProfileScreen(
        onNavigateToMyPets: () => _onTabTapped(1),
        onNavigateToVaccines: () => _onTabTapped(2),
        onNotificationTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const VaccinationRemindersScreen(),
            ),
          );
        },
        notificationCount: activeReminders.length,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E293B).withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.pets_rounded, 'Home'),
                _buildNavItem(1, Icons.cruelty_free_rounded, 'My Pets'),
                _buildNavItem(2, Icons.vaccines_rounded, 'Vaccines'),
                _buildNavItem(3, Icons.account_circle_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryFixed : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// InheritedWidget helper to access PetService cleanly across screens
class PetServiceHolder extends InheritedWidget {
  final PetService petService;

  const PetServiceHolder({
    super.key,
    required this.petService,
    required super.child,
  });

  static PetService of(BuildContext context) {
    final holder = context.dependOnInheritedWidgetOfExactType<PetServiceHolder>();
    assert(holder != null, 'No PetServiceHolder found in context');
    return holder!.petService;
  }

  @override
  bool updateShouldNotify(PetServiceHolder oldWidget) =>
      petService != oldWidget.petService;
}
