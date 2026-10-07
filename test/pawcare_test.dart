import 'package:flutter_test/flutter_test.dart';
import 'package:pawcare/models/enums.dart';
import 'package:pawcare/models/pet.dart';
import 'package:pawcare/models/vaccination.dart';
import 'package:pawcare/services/auth_service.dart';
import 'package:pawcare/services/local_storage_service.dart';
import 'package:pawcare/services/pet_service.dart';
import 'package:pawcare/utils/vaccination_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VaccinationUtils Dynamic Calculation Tests', () {
    test('Calculates OVERDUE when nextDueDate is before today', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 10));
      final status = VaccinationUtils.calculateVaccinationStatus(pastDate);
      expect(status, equals(VaccinationStatus.overdue));
    });

    test('Calculates DUE SOON when nextDueDate is within 30 days', () {
      final dueSoonDate = DateTime.now().add(const Duration(days: 15));
      final status = VaccinationUtils.calculateVaccinationStatus(dueSoonDate);
      expect(status, equals(VaccinationStatus.dueSoon));
    });

    test('Calculates UP TO DATE when nextDueDate is more than 30 days away', () {
      final futureDate = DateTime.now().add(const Duration(days: 90));
      final status = VaccinationUtils.calculateVaccinationStatus(futureDate);
      expect(status, equals(VaccinationStatus.upToDate));
    });

    test('Calculates overall pet status as OVERDUE if any vaccine is overdue', () {
      final pet = Pet(
        id: 'test_1',
        name: 'Test Bruno',
        breed: 'Retriever',
        age: '2 Years',
        gender: PetGender.male,
        category: PetCategory.dogs,
        image: '',
        description: 'Test',
        vaccinations: [
          Vaccination(
            id: 'v1',
            vaccineName: 'Rabies',
            dateGiven: DateTime.now().subtract(const Duration(days: 400)),
            nextDueDate: DateTime.now().subtract(const Duration(days: 35)), // Overdue
          ),
          Vaccination(
            id: 'v2',
            vaccineName: 'DHPP',
            dateGiven: DateTime.now().subtract(const Duration(days: 100)),
            nextDueDate: DateTime.now().add(const Duration(days: 200)), // Up to date
          ),
        ],
      );

      final overall = VaccinationUtils.calculateOverallPetStatus(pet);
      expect(overall, equals(VaccinationStatus.overdue));
    });

    test('Calculates days remaining accurately', () {
      final targetDate = DateTime.now().add(const Duration(days: 7));
      final days = VaccinationUtils.calculateDaysRemaining(targetDate);
      expect(days, equals(7));
    });
  });

  group('PetService & Local Persistence Tests', () {
    late LocalStorageService storageService;
    late PetService petService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storageService = LocalStorageService(prefs);
      petService = PetService(storageService);
    });

    test('Initializes with seed pets (Bruno, Luna, Max, Bella)', () {
      expect(petService.allPets.length, greaterThanOrEqualTo(4));
      final bruno = petService.allPets.firstWhere((p) => p.name == 'Bruno');
      expect(bruno.breed, equals('Golden Retriever'));
      final bella = petService.allPets.firstWhere((p) => p.name == 'Bella');
      expect(bella.adoptionStatus, equals(AdoptionStatus.available));
    });

    test('Adopting Bella moves her from Available Pets to My Pets and persists', () async {
      final bella = petService.allPets.firstWhere((p) => p.name == 'Bella');
      expect(petService.getAvailablePets().any((p) => p.id == bella.id), isTrue);
      expect(petService.getAdoptedPets().any((p) => p.id == bella.id), isFalse);

      final success = await petService.adoptPet(bella.id);
      expect(success, isTrue);

      // Now Bella is adopted
      expect(petService.getAvailablePets().any((p) => p.id == bella.id), isFalse);
      expect(petService.getAdoptedPets().any((p) => p.id == bella.id), isTrue);

      // Reload from storage to verify real persistence
      final reloadedPets = storageService.loadPets();
      expect(reloadedPets, isNotNull);
      final reloadedBella = reloadedPets!.firstWhere((p) => p.id == bella.id);
      expect(reloadedBella.adoptionStatus, equals(AdoptionStatus.adopted));
    });

    test('Adding a vaccination record updates history and persists', () async {
      final bruno = petService.allPets.firstWhere((p) => p.name == 'Bruno');
      final initialCount = bruno.vaccinations.length;

      final now = DateTime.now();
      final addSuccess = await petService.addVaccination(
        petId: bruno.id,
        vaccineName: 'Kennel Cough Booster',
        dateGiven: now,
        nextDueDate: now.add(const Duration(days: 180)),
        notes: 'Administered at local clinic',
      );
      expect(addSuccess, isTrue);

      final updatedBruno = petService.getPetById(bruno.id);
      expect(updatedBruno!.vaccinations.length, equals(initialCount + 1));
      expect(updatedBruno.vaccinations.first.vaccineName, equals('Kennel Cough Booster'));
    });

    test('Shelter can add a new pet and it appears in available pets', () async {
      final newPet = Pet(
        id: 'pet_charlie_new',
        name: 'Charlie',
        breed: 'Beagle',
        age: '1.5 Years',
        gender: PetGender.male,
        category: PetCategory.dogs,
        image: 'https://example.com/beagle.jpg',
        description: 'Friendly beagle puppy.',
        shelterName: 'Austin Animal Rescue',
        adoptionStatus: AdoptionStatus.available,
      );

      await petService.addPet(newPet);

      final available = petService.getAvailablePets();
      expect(available.any((p) => p.name == 'Charlie'), isTrue);
    });

    test('Searching and filtering pets works locally', () {
      final dogs = petService.getAvailablePets(category: PetCategory.dogs);
      expect(dogs.every((p) => p.category == PetCategory.dogs), isTrue);

      final searchResults = petService.getAvailablePets(query: 'bella');
      expect(searchResults.length, equals(1));
      expect(searchResults.first.name, equals('Bella'));
    });

    test('Data survives service re-instantiation simulating app restart', () async {
      // 1. Adopt Bruno and add new vaccination
      final bruno = petService.allPets.firstWhere((p) => p.name == 'Bruno');
      await petService.adoptPet(bruno.id);
      final pastDate = DateTime.now().subtract(const Duration(days: 10));
      await petService.addVaccination(
        petId: bruno.id,
        vaccineName: 'Past Overdue Vaccine',
        dateGiven: pastDate.subtract(const Duration(days: 365)),
        nextDueDate: pastDate,
      );

      // 2. Simulate fresh app start with newly instantiated service
      final newPetService = PetService(storageService);
      final reloadedBruno = newPetService.getPetById(bruno.id);

      expect(reloadedBruno, isNotNull);
      expect(reloadedBruno!.adoptionStatus, equals(AdoptionStatus.adopted));
      expect(reloadedBruno.vaccinations.any((v) => v.vaccineName == 'Past Overdue Vaccine'), isTrue);

      // 3. Verify overdue calculation on reloaded instance
      final overallStatus = VaccinationUtils.calculateOverallPetStatus(reloadedBruno);
      expect(overallStatus, equals(VaccinationStatus.overdue));
    });
  });

  group('AuthService Local Authentication Tests', () {
    late LocalStorageService storageService;
    late AuthService authService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storageService = LocalStorageService(prefs);
      authService = AuthService(storageService);
    });

    test('Sign Up validates password length and creates account locally', () async {
      final failResult = await authService.signUp(
        name: 'Sarah Connor',
        email: 'sarah@example.com',
        password: '123',
        confirmPassword: '123',
      );
      expect(failResult.isSuccess, isFalse);

      final successResult = await authService.signUp(
        name: 'Sarah Connor',
        email: 'sarah@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      );
      expect(successResult.isSuccess, isTrue);
      expect(authService.isLoggedIn, isTrue);
      expect(authService.currentUser?.email, equals('sarah@example.com'));
    });

    test('Login validates credentials and logout clears session', () async {
      await authService.signUp(
        name: 'John Doe',
        email: 'john@example.com',
        password: 'securePassword!',
        confirmPassword: 'securePassword!',
      );

      await authService.logout();
      expect(authService.isLoggedIn, isFalse);

      final wrongPass = await authService.login(
        email: 'john@example.com',
        password: 'wrongPassword',
      );
      expect(wrongPass.isSuccess, isFalse);

      final correctPass = await authService.login(
        email: 'john@example.com',
        password: 'securePassword!',
      );
      expect(correctPass.isSuccess, isTrue);
      expect(authService.isLoggedIn, isTrue);
    });

    test('Sign Up rejects duplicate email registration', () async {
      await authService.signUp(
        name: 'Test User',
        email: 'duplicate@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      );

      final duplicateResult = await authService.signUp(
        name: 'Another User',
        email: 'duplicate@example.com',
        password: 'password456',
        confirmPassword: 'password456',
      );
      expect(duplicateResult.isSuccess, isFalse);
      expect(duplicateResult.errorMessage, contains('already exists'));
    });
  });
}
