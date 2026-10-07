import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'screens/add_vaccination/add_vaccination_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/pet_profile/pet_profile_screen.dart';
import 'screens/reminders/vaccination_reminders_screen.dart';
import 'screens/shelter/shelter_add_pet_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/vaccinations/pet_vaccination_details_screen.dart';
import 'screens/welcome/welcome_screen.dart';
import 'services/auth_service.dart';
import 'services/local_storage_service.dart';
import 'services/pet_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientation and system overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization notice: $e');
  }

  final storageService = await LocalStorageService.create();
  final authService = AuthService(storageService);
  final petService = PetService(storageService);

  runApp(
    PawCareApp(
      authService: authService,
      petService: petService,
    ),
  );
}

class PawCareApp extends StatelessWidget {
  final AuthService authService;
  final PetService petService;

  const PawCareApp({
    super.key,
    required this.authService,
    required this.petService,
  });

  Widget _resolveHomeScreen() {
    String screen = Uri.base.queryParameters['screen'] ?? '';
    if (screen.isEmpty && Uri.base.fragment.isNotEmpty) {
      screen = Uri.base.fragment.replaceAll('/', '').replaceAll('#', '').trim();
    }
    final petId = Uri.base.queryParameters['id'] ?? 'pet_bruno_in_03';

    switch (screen) {
      case 'welcome':
        return const WelcomeScreen();
      case 'login':
        return const LoginScreen();
      case 'signup':
        return const SignUpScreen();
      case 'home':
        return const MainNavigationScreen(initialIndex: 0);
      case 'mypets':
        return const MainNavigationScreen(initialIndex: 1);
      case 'vaccines':
        return const MainNavigationScreen(initialIndex: 2);
      case 'profile':
        return const MainNavigationScreen(initialIndex: 3);
      case 'pet_details':
        return PetProfileScreen(petId: petId);
      case 'vaccine_timeline':
        return PetVaccinationDetailsScreen(petId: petId);
      case 'add_vaccine':
        return AddVaccinationScreen(petId: petId);
      case 'shelter':
        return const ShelterAddPetScreen();
      case 'reminders':
        return const VaccinationRemindersScreen();
      default:
        return SplashScreen(authService: authService);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthServiceHolder(
      authService: authService,
      child: PetServiceHolder(
        petService: petService,
        child: AnimatedBuilder(
          animation: Listenable.merge([authService, petService]),
          builder: (context, _) {
            return MaterialApp(
              title: 'PawCare',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              home: _resolveHomeScreen(),
            );
          },
        ),
      ),
    );
  }
}


