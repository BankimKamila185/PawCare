import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawcare/main.dart';
import 'package:pawcare/services/auth_service.dart';
import 'package:pawcare/services/local_storage_service.dart';
import 'package:pawcare/services/pet_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('PawCareApp renders successfully and loads initial state', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storageService = LocalStorageService(prefs);
    final authService = AuthService(storageService);
    final petService = PetService(storageService);

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      PawCareApp(
        authService: authService,
        petService: petService,
      ),
    );

    // Initial frame renders splash screen with brand title
    expect(find.text('PawCare'), findsWidgets);

    // Let the splash timer settle
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Navigates to main screen
    expect(find.text('PawCare'), findsWidgets);
  });
}
