import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/enums.dart';
import '../models/pet.dart';
import '../models/vaccination.dart';
import '../utils/vaccination_utils.dart';
import 'local_storage_service.dart';

class PetService extends ChangeNotifier {
  final LocalStorageService _storage;
  List<Pet> _pets = [];

  PetService(this._storage) {
    _initPets();
  }

  List<Pet> get allPets => List.unmodifiable(_pets);

  void _initPets() {
    final saved = _storage.loadPets();
    if (saved != null && saved.isNotEmpty) {
      _pets = saved;
    } else {
      _pets = _getSeedPets();
      _storage.savePets(_pets);
    }
    notifyListeners();
  }

  static List<Pet> _getSeedPets() {
    final now = DateTime.now();

    return [
      Pet(
        id: 'pet_bruno_01',
        name: 'Bruno',
        breed: 'Golden Retriever',
        age: '2 Years',
        gender: PetGender.male,
        category: PetCategory.dogs,
        image:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAZaNYhpcLX-1zVFpzTQ2f9RqI6WLFkgRDIPcOcoF84_aRvBguBk7irYZZ1JiS2E1cNBnDsnIOstU_vK6XLvycugCL1IhbnKzJz-fLTkz6QhCaV-y_KO9C16p44eQiyuLbEivv5QqyFJD-E0HAPj9c5wFdh5bkatThFVC-k4ILpoiPp8RAASPNPR96m2UFpt1hS9ezlW7Bk7xsZ91WzZx5VLtdcdmZ8u40YNd-yqF-z6opKg5AcJMES',
        description:
            'Bruno is an energetic, affectionate Golden Retriever who loves outdoor games, fetch, and belly rubs. He is gentle, well-mannered, and looking for a loving home.',
        shelterName: 'Happy Tails Shelter',
        location: 'Austin, TX',
        distance: '3.2 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Good with Children', 'Pet Friendly', 'Trained'],
        vaccinations: [
          Vaccination(
            id: 'vac_bruno_01',
            vaccineName: 'Rabies Booster',
            dateGiven: now.subtract(const Duration(days: 350)),
            nextDueDate: now.add(const Duration(days: 12)), // Due Soon (12 days)
            category: 'Upcoming (Booster)',
            notes: 'Annual booster dose for anti-rabies immunity.',
          ),
          Vaccination(
            id: 'vac_bruno_02',
            vaccineName: 'DHPP Core',
            dateGiven: now.subtract(const Duration(days: 110)),
            nextDueDate: now.add(const Duration(days: 255)),
            category: 'Core',
            notes: 'Distemper, Hepatitis, Parvovirus, Parainfluenza core shot.',
          ),
          Vaccination(
            id: 'vac_bruno_03',
            vaccineName: 'Anti-Rabies Core Vaccine',
            dateGiven: now.subtract(const Duration(days: 365)),
            nextDueDate: now.subtract(const Duration(days: 15)),
            category: 'Initial Immunization',
            notes: 'Initial puppy dose administered successfully.',
          ),
        ],
      ),
      Pet(
        id: 'pet_luna_02',
        name: 'Luna',
        breed: 'Persian Cat',
        age: '1 Year',
        gender: PetGender.female,
        category: PetCategory.cats,
        image:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAY3L3DSoYaaVwPYFhZe184vpyqtHbv-y0RH5nQ27qkj53kP92LHZV4kWEqyJ263riHnUuMHHPd1ItpOpLG22640p-pUBdVGslUr4kszCZqo0g5irpQSDNqi-xjh1TYDwZcQtmNnhdLW6yd1XcpnkJkCzEcfBSyz8DxTce8FVPxlimBVP5k6aaNIJwEAuRwTI4njW1_MIuucplmbBXKB-tpV6OPTYRtGVSb-zJ0TcZ4fGhyz47AKAqC',
        description:
            'Luna is a graceful, quiet Persian cat who enjoys warm afternoon sunbeams, gentle brush strokes, and lap naps. Fully indoor-trained and sweet-tempered.',
        shelterName: 'City Paws Shelter',
        location: 'Austin, TX',
        distance: '1.8 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Calm Nature', 'Indoor Only', 'Gentle'],
        vaccinations: [
          Vaccination(
            id: 'vac_luna_01',
            vaccineName: 'FVRCP Core Vaccine',
            dateGiven: now.subtract(const Duration(days: 90)),
            nextDueDate: now.add(const Duration(days: 120)), // Up to Date
            category: 'Core',
            notes: 'Feline Viral Rhinotracheitis, Calicivirus, Panleukopenia.',
          ),
          Vaccination(
            id: 'vac_luna_02',
            vaccineName: 'Feline Rabies Shot',
            dateGiven: now.subtract(const Duration(days: 150)),
            nextDueDate: now.add(const Duration(days: 215)),
            category: 'Core',
            notes: 'Required annual anti-rabies vaccination.',
          ),
        ],
      ),
      Pet(
        id: 'pet_max_03',
        name: 'Max',
        breed: 'Labrador Retriever',
        age: '3 Years',
        gender: PetGender.male,
        category: PetCategory.dogs,
        image:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB8yGgGdlQ2QHBEmqR8mKmxvE2LRpXij4wKmzKwgVH_i8S0_HBeV4tRwY-9xEm4F6l-EgSsouEeCcIJVXKMbpIndSeXmQ6WUm1y4fYwWCkfuBvUnaV8yZkNtsvgz0Dm1AAbn-dWZRoe5-TTVLOcMwsG9ca4TigYszsEXmrelhFON9wj9mxUBt6u_bkgO2-8Vy75uSwyLmBb_v-p58e_BgsEMuJrdjlc-CngHXGTjdRP6F46o-J9nPTW',
        description:
            'Max is a loyal, high-spirited Labrador who loves swimming, hiking, and learning new agility tricks. Very friendly with people and other pets.',
        shelterName: 'Eastside Haven',
        location: 'Austin, TX',
        distance: '4.1 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Active Lifestyle', 'Trainable', 'Swimmer'],
        vaccinations: [
          Vaccination(
            id: 'vac_max_01',
            vaccineName: 'Canine Parvovirus',
            dateGiven: now.subtract(const Duration(days: 180)),
            nextDueDate: now.add(const Duration(days: 60)), // Up to date
            category: 'Core',
            notes: 'Standard Parvovirus immunization booster.',
          ),
          Vaccination(
            id: 'vac_max_02',
            vaccineName: 'Bordetella (Kennel Cough)',
            dateGiven: now.subtract(const Duration(days: 370)),
            nextDueDate: now.subtract(const Duration(days: 5)), // Overdue!
            category: 'Booster',
            notes: 'Semi-annual respiratory protection shot.',
          ),
        ],
      ),
      Pet(
        id: 'pet_bella_04',
        name: 'Bella',
        breed: 'Indie Pup',
        age: '8 Months',
        gender: PetGender.female,
        category: PetCategory.dogs,
        image:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCY_-bauQpsREvIdsmHPaY__JNMLZYO11u_ipAaEHiEaLU4nPDjNIXlPaHzXDS93Nd3uMOpDMpgk9anPkqqBVfYeTxNX9dsnAiuy42P_wqLucl6JLJdi4PBNPy4Pb0XR2bzdDMGhxos573w5NMsDkrgHhvB3To3AYih1M1UYyFD7FbPzeOWZjLY3TZVnDSi7FfPDdljXly5GVJCN4pGkwlbeSRSUZ_DQy3Vt1q1zd52wPrTzBei5XKQ',
        description:
            'Bella is an adorable, alert Indie mongrel puppy with large expressive ears and honey-brown eyes. Full of curiosity and eager to learn.',
        shelterName: 'Sunshine Shelter',
        location: 'Austin, TX',
        distance: '5.0 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Playful', 'Quick Learner', 'Affectionate'],
        vaccinations: [
          Vaccination(
            id: 'vac_bella_01',
            vaccineName: 'Puppy DAPP Series',
            dateGiven: now.subtract(const Duration(days: 60)),
            nextDueDate: now.add(const Duration(days: 20)), // Due Soon (20 days)
            category: 'Core',
            notes: 'Second puppy core vaccine dose.',
          ),
        ],
      ),
    ];
  }

  // ==================== QUERY METHODS ====================

  /// Get available pets for adoption with optional category and search query.
  List<Pet> getAvailablePets({PetCategory category = PetCategory.all, String query = ''}) {
    return _pets.where((pet) {
      if (pet.adoptionStatus != AdoptionStatus.available) return false;

      // Category filter
      if (category == PetCategory.dogs && pet.category != PetCategory.dogs) return false;
      if (category == PetCategory.cats && pet.category != PetCategory.cats) return false;

      // Search query filter
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        final matchName = pet.name.toLowerCase().contains(q);
        final matchBreed = pet.breed.toLowerCase().contains(q);
        final matchShelter = pet.shelterName.toLowerCase().contains(q);
        if (!matchName && !matchBreed && !matchShelter) return false;
      }

      return true;
    }).toList();
  }

  /// Get adopted pets (My Pets).
  List<Pet> getAdoptedPets() {
    return _pets.where((p) => p.adoptionStatus == AdoptionStatus.adopted).toList();
  }

  /// Get pet by ID.
  Pet? getPetById(String id) {
    try {
      return _pets.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // ==================== ADOPTION & UPDATES ====================

  /// Confirm adoption of a pet: changes status to adopted and saves locally.
  Future<bool> adoptPet(String petId) async {
    final index = _pets.indexWhere((p) => p.id == petId);
    if (index == -1) return false;

    _pets[index] = _pets[index].copyWith(
      adoptionStatus: AdoptionStatus.adopted,
    );
    await _storage.savePets(_pets);
    notifyListeners();
    return true;
  }

  /// Toggle favorite status of a pet.
  Future<void> toggleFavorite(String petId) async {
    final index = _pets.indexWhere((p) => p.id == petId);
    if (index == -1) return;

    _pets[index] = _pets[index].copyWith(
      isFavorite: !_pets[index].isFavorite,
    );
    await _storage.savePets(_pets);
    notifyListeners();
  }

  /// Add a vaccination record to a pet.
  Future<bool> addVaccination({
    required String petId,
    required String vaccineName,
    required DateTime dateGiven,
    required DateTime nextDueDate,
    String notes = '',
    String category = 'Core',
  }) async {
    final index = _pets.indexWhere((p) => p.id == petId);
    if (index == -1) return false;

    final newVac = Vaccination(
      id: const Uuid().v4(),
      vaccineName: vaccineName,
      dateGiven: dateGiven,
      nextDueDate: nextDueDate,
      notes: notes,
      category: category,
      isCompleted: true,
    );

    final updatedVaccinations = List<Vaccination>.from(_pets[index].vaccinations)
      ..insert(0, newVac);

    _pets[index] = _pets[index].copyWith(
      vaccinations: updatedVaccinations,
    );

    await _storage.savePets(_pets);
    notifyListeners();
    return true;
  }

  /// Add a new pet (e.g. by Shelter).
  Future<void> addPet(Pet pet) async {
    _pets.insert(0, pet);
    await _storage.savePets(_pets);
    notifyListeners();
  }

  // ==================== METRICS & REMINDERS ====================

  /// Count of total adopted pets.
  int get totalAdoptedPetsCount => getAdoptedPets().length;

  /// Count of adopted pets that are up to date.
  int get upToDateAdoptedPetsCount {
    return getAdoptedPets()
        .where((p) => VaccinationUtils.calculateOverallPetStatus(p) == VaccinationStatus.upToDate)
        .length;
  }

  /// Count of adopted pets that have vaccines due soon.
  int get dueSoonAdoptedPetsCount {
    return getAdoptedPets()
        .where((p) => VaccinationUtils.calculateOverallPetStatus(p) == VaccinationStatus.dueSoon)
        .length;
  }

  /// Count of adopted pets that have overdue vaccines.
  int get overdueAdoptedPetsCount {
    return getAdoptedPets()
        .where((p) => VaccinationUtils.calculateOverallPetStatus(p) == VaccinationStatus.overdue)
        .length;
  }

  /// Generate active vaccination reminder items for adopted pets.
  List<VaccinationReminderItem> getActiveReminders() {
    final adopted = getAdoptedPets();
    final List<VaccinationReminderItem> reminders = [];

    for (final pet in adopted) {
      for (final vac in pet.vaccinations) {
        final status = VaccinationUtils.calculateVaccinationStatus(vac.nextDueDate);
        if (status == VaccinationStatus.dueSoon || status == VaccinationStatus.overdue) {
          final days = VaccinationUtils.calculateDaysRemaining(vac.nextDueDate);
          reminders.add(
            VaccinationReminderItem(
              id: '${pet.id}_${vac.id}',
              pet: pet,
              vaccination: vac,
              status: status,
              daysRemaining: days,
            ),
          );
        }
      }
    }

    return reminders;
  }

  /// Reset to seed data (useful for testing).
  Future<void> resetToSeedData() async {
    _pets = _getSeedPets();
    await _storage.savePets(_pets);
    notifyListeners();
  }
}

class VaccinationReminderItem {
  final String id;
  final Pet pet;
  final Vaccination vaccination;
  final VaccinationStatus status;
  final int daysRemaining;

  const VaccinationReminderItem({
    required this.id,
    required this.pet,
    required this.vaccination,
    required this.status,
    required this.daysRemaining,
  });

  String get title {
    if (status == VaccinationStatus.overdue) {
      return "${pet.name}'s ${vaccination.vaccineName} is Overdue";
    }
    if (daysRemaining <= 0) {
      return "${pet.name}'s ${vaccination.vaccineName} is Due Today!";
    }
    return "${pet.name}'s ${vaccination.vaccineName} is due in $daysRemaining days.";
  }

  String get subtitle {
    if (status == VaccinationStatus.overdue) {
      return "Missed target date: ${VaccinationUtils.formatDate(vaccination.nextDueDate, short: true)}. Please schedule a booster.";
    }
    return "Target date: ${VaccinationUtils.formatDate(vaccination.nextDueDate, short: true)}.";
  }
}
