import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/splash/splash_screen.dart';
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
              home: SplashScreen(authService: authService),
            );
          },
        ),
      ),
    );
  }
}
