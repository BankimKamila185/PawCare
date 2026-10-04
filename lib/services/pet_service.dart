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
    // Auto-migrate if empty or older 4-pet legacy demo dataset
    final isLegacy = saved != null &&
        (saved.length <= 4 || saved.any((p) => p.location.contains('Austin')));

    if (saved != null && saved.isNotEmpty && !isLegacy) {
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
        id: 'pet_sheru_in_01',
        name: 'Sheru',
        breed: 'Indian Pariah Dog (Desi Indie)',
        age: '1.5 Years',
        gender: PetGender.male,
        category: PetCategory.dogs,
        image:
            'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=800&q=80',
        description:
            'Sheru is a vigilant, highly intelligent Indie rescue from Indiranagar. He possesses exceptional natural immunity, is very loving with family members, and is perfectly adapted to apartment life.',
        shelterName: 'CUPA Rescue Center',
        location: 'Indiranagar, Bengaluru, KA',
        distance: '2.4 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Native Indian Breed', 'High Immunity', 'Loyal & Friendly', 'Apartment Friendly'],
        vaccinations: [
          Vaccination(
            id: 'vac_sheru_01',
            vaccineName: 'Anti-Rabies Core (Nobivac)',
            dateGiven: now.subtract(const Duration(days: 350)),
            nextDueDate: now.add(const Duration(days: 15)), // Due Soon (15 days)
            category: 'Core',
            notes: 'Annual mandatory rabies booster for municipal compliance.',
          ),
          Vaccination(
            id: 'vac_sheru_02',
            vaccineName: 'DHPPiL 9-in-1 (Monsoon Protection)',
            dateGiven: now.subtract(const Duration(days: 120)),
            nextDueDate: now.add(const Duration(days: 245)),
            category: 'Core',
            notes: 'Covers Distemper, Parvo, Infectious Hepatitis, and Leptospirosis.',
          ),
          Vaccination(
            id: 'vac_sheru_03',
            vaccineName: 'Canine Deworming & Tick Shield',
            dateGiven: now.subtract(const Duration(days: 45)),
            nextDueDate: now.add(const Duration(days: 45)),
            category: 'Booster',
            notes: 'Quarterly broad-spectrum internal parasite prophylaxis.',
          ),
        ],
      ),
      Pet(
        id: 'pet_bella_in_02',
        name: 'Bella',
        breed: 'Indie Mix Pup',
        age: '6 Months',
        gender: PetGender.female,
        category: PetCategory.dogs,
        image:
            'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&w=800&q=80',
        description:
            'Bella is an adorable, alert Indie mongrel puppy rescued by YODA volunteers in Bandra. She is super affectionate with children, loves squeaky toys, and is already leash trained.',
        shelterName: 'YODA Animal Shelter',
        location: 'Bandra West, Mumbai, MH',
        distance: '1.8 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Good with Children', 'Playful', 'Quick Learner', 'Dewormed'],
        vaccinations: [
          Vaccination(
            id: 'vac_bella_01',
            vaccineName: 'Puppy DAPP Series',
            dateGiven: now.subtract(const Duration(days: 45)),
            nextDueDate: now.add(const Duration(days: 18)), // Due Soon (18 days)
            category: 'Initial Immunization',
            notes: 'Second puppy core vaccine dose administered successfully.',
          ),
          Vaccination(
            id: 'vac_bella_02',
            vaccineName: 'Anti-Rabies Initial Dose',
            dateGiven: now.subtract(const Duration(days: 90)),
            nextDueDate: now.add(const Duration(days: 275)),
            category: 'Core',
            notes: 'Primary rabies immunization for puppy.',
          ),
        ],
      ),
      Pet(
        id: 'pet_bruno_in_03',
        name: 'Bruno',
        breed: 'Golden Retriever',
        age: '2 Years',
        gender: PetGender.male,
        category: PetCategory.dogs,
        image:
            'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=800&q=80',
        description:
            'Bruno is an energetic, gentle Golden Retriever looking for a loving home in South Delhi. He is well-mannered, gets along with other dogs, and loves morning walks in Lodhi Garden.',
        shelterName: 'Friendicoes SECA',
        location: 'Defence Colony, New Delhi, DL',
        distance: '3.5 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Family Friendly', 'Trained', 'Gentle Giant', 'Swimmer'],
        vaccinations: [
          Vaccination(
            id: 'vac_bruno_01',
            vaccineName: 'Rabies Booster (Annual)',
            dateGiven: now.subtract(const Duration(days: 355)),
            nextDueDate: now.add(const Duration(days: 10)), // Due Soon (10 days)
            category: 'Core',
            notes: 'Annual booster dose for anti-rabies immunity.',
          ),
          Vaccination(
            id: 'vac_bruno_02',
            vaccineName: 'DHPP 7-in-1 Core',
            dateGiven: now.subtract(const Duration(days: 110)),
            nextDueDate: now.add(const Duration(days: 255)),
            category: 'Core',
            notes: 'Distemper, Hepatitis, Parvovirus, Parainfluenza core shot.',
          ),
          Vaccination(
            id: 'vac_bruno_03',
            vaccineName: 'Bordetella (Kennel Cough)',
            dateGiven: now.subtract(const Duration(days: 375)),
            nextDueDate: now.subtract(const Duration(days: 10)), // Overdue!
            category: 'Booster',
            notes: 'Overdue semi-annual respiratory shot. Booster appointment required.',
          ),
        ],
      ),
      Pet(
        id: 'pet_luna_in_04',
        name: 'Luna',
        breed: 'Persian Cat',
        age: '1.5 Years',
        gender: PetGender.female,
        category: PetCategory.cats,
        image:
            'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=800&q=80',
        description:
            'Luna is a graceful, quiet Persian cat who enjoys warm afternoon sunbeams, gentle brush strokes, and lap naps. Fully indoor-trained, vaccinated, and sweet-tempered.',
        shelterName: 'RESQ Charitable Trust',
        location: 'Koregaon Park, Pune, MH',
        distance: '2.1 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Calm Nature', 'Indoor Only', 'Silky Coat', 'Sterilized'],
        vaccinations: [
          Vaccination(
            id: 'vac_luna_01',
            vaccineName: 'FVRCP Tricat Core Vaccine',
            dateGiven: now.subtract(const Duration(days: 80)),
            nextDueDate: now.add(const Duration(days: 130)), // Up to Date
            category: 'Core',
            notes: 'Feline Viral Rhinotracheitis, Calicivirus, Panleukopenia.',
          ),
          Vaccination(
            id: 'vac_luna_02',
            vaccineName: 'Feline Anti-Rabies Shot',
            dateGiven: now.subtract(const Duration(days: 150)),
            nextDueDate: now.add(const Duration(days: 215)),
            category: 'Core',
            notes: 'Required annual anti-rabies feline vaccination.',
          ),
        ],
      ),
      Pet(
        id: 'pet_mimi_in_05',
        name: 'Mimi',
        breed: 'Indian Domestic Shorthair (Desi Billi)',
        age: '1 Year',
        gender: PetGender.female,
        category: PetCategory.cats,
        image:
            'https://images.unsplash.com/photo-1533738363-b7f9aef128ce?auto=format&fit=crop&w=800&q=80',
        description:
            'Mimi is an adorable ginger tabby Indie cat rescued in Koramangala. She is extremely vocal, affectionate, loves playing with feather wands, and is 100% litter box trained.',
        shelterName: 'CUPA Second Chance Sanctuary',
        location: 'Sarjapur Road, Bengaluru, KA',
        distance: '3.8 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Playful', 'Litter Trained', 'Affectionate', 'Indoor Cat'],
        vaccinations: [
          Vaccination(
            id: 'vac_mimi_01',
            vaccineName: 'FVRCP Tricat Feline Core',
            dateGiven: now.subtract(const Duration(days: 90)),
            nextDueDate: now.add(const Duration(days: 95)), // Up to Date
            category: 'Core',
            notes: 'Protects against feline respiratory viruses and panleukopenia.',
          ),
          Vaccination(
            id: 'vac_mimi_02',
            vaccineName: 'Anti-Rabies Core Shot',
            dateGiven: now.subtract(const Duration(days: 100)),
            nextDueDate: now.add(const Duration(days: 265)),
            category: 'Core',
            notes: 'Annual rabies prophylaxis given at Cessna Lifeline Vet Clinic.',
          ),
        ],
      ),
      Pet(
        id: 'pet_raja_in_06',
        name: 'Raja',
        breed: 'Rajapalayam (Royal Indian Hound)',
        age: '2.5 Years',
        gender: PetGender.male,
        category: PetCategory.dogs,
        image:
            'https://images.unsplash.com/photo-1561037404-61cd46aa615b?auto=format&fit=crop&w=800&q=80',
        description:
            'Raja is a magnificent pure-white Rajapalayam hound from Tamil Nadu. Highly alert, majestic, and devoted to his human family. Needs a home with a yard or an active guardian.',
        shelterName: 'Blue Cross of India',
        location: 'Guindy, Chennai, TN',
        distance: '4.2 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Royal Indian Breed', 'Vigilant Guardian', 'Athletic', 'Vaccinated'],
        vaccinations: [
          Vaccination(
            id: 'vac_raja_01',
            vaccineName: 'Anti-Rabies (Mandatory Core)',
            dateGiven: now.subtract(const Duration(days: 65)),
            nextDueDate: now.add(const Duration(days: 300)),
            category: 'Core',
            notes: 'Mandatory annual anti-rabies dose administered.',
          ),
          Vaccination(
            id: 'vac_raja_02',
            vaccineName: 'DHPPiL 9-in-1 (Distemper & Lepto)',
            dateGiven: now.subtract(const Duration(days: 180)),
            nextDueDate: now.add(const Duration(days: 185)),
            category: 'Core',
            notes: 'Annual booster for viral and bacterial monsoon pathogens.',
          ),
        ],
      ),
      Pet(
        id: 'pet_snowy_in_07',
        name: 'Snowy',
        breed: 'Indian Spitz',
        age: '2 Years',
        gender: PetGender.male,
        category: PetCategory.dogs,
        image:
            'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?auto=format&fit=crop&w=800&q=80',
        description:
            'Snowy is a delightful, fluffy white Indian Spitz with perky ears and a bushy tail. Alert watchdog, friendly with family members, and loves afternoon snacks and tricks.',
        shelterName: 'Help In Suffering (HIS)',
        location: 'C-Scheme, Jaipur, RJ',
        distance: '1.9 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Alert Watchdog', 'Fluffy Coat', 'Apartment Friendly', 'Healthy'],
        vaccinations: [
          Vaccination(
            id: 'vac_snowy_01',
            vaccineName: 'Anti-Rabies Booster',
            dateGiven: now.subtract(const Duration(days: 340)),
            nextDueDate: now.add(const Duration(days: 25)), // Due Soon (25 days)
            category: 'Booster',
            notes: 'Annual rabies protection booster due before month end.',
          ),
          Vaccination(
            id: 'vac_snowy_02',
            vaccineName: 'DHPP Core Vaccine',
            dateGiven: now.subtract(const Duration(days: 140)),
            nextDueDate: now.add(const Duration(days: 225)),
            category: 'Core',
            notes: 'Standard 7-in-1 combo immunization.',
          ),
        ],
      ),
      Pet(
        id: 'pet_max_in_08',
        name: 'Max',
        breed: 'Labrador Retriever',
        age: '3 Years',
        gender: PetGender.male,
        category: PetCategory.dogs,
        image:
            'https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&w=800&q=80',
        description:
            'Max is a loyal, chocolate Labrador who loves playing fetch at Juhu Beach. Well-mannered on walks, trained for basic commands, and wonderful with kids.',
        shelterName: 'YODA Animal Shelter',
        location: 'Juhu, Mumbai, MH',
        distance: '3.1 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Great with Kids', 'Water Lover', 'Obedient', 'Neutered'],
        vaccinations: [
          Vaccination(
            id: 'vac_max_01',
            vaccineName: 'Canine Parvovirus Booster',
            dateGiven: now.subtract(const Duration(days: 180)),
            nextDueDate: now.add(const Duration(days: 60)), // Up to date
            category: 'Core',
            notes: 'Standard Parvovirus immunization booster.',
          ),
          Vaccination(
            id: 'vac_max_02',
            vaccineName: 'Bordetella (Kennel Cough)',
            dateGiven: now.subtract(const Duration(days: 372)),
            nextDueDate: now.subtract(const Duration(days: 7)), // Overdue!
            category: 'Booster',
            notes: 'Semi-annual respiratory protection shot is overdue.',
          ),
          Vaccination(
            id: 'vac_max_03',
            vaccineName: 'Anti-Rabies Core Shot',
            dateGiven: now.subtract(const Duration(days: 55)),
            nextDueDate: now.add(const Duration(days: 310)),
            category: 'Core',
            notes: 'Annual Nobivac rabies protection verified.',
          ),
        ],
      ),
      Pet(
        id: 'pet_simba_in_09',
        name: 'Simba',
        breed: 'Indian Calico (Desi Billi)',
        age: '9 Months',
        gender: PetGender.male,
        category: PetCategory.cats,
        image:
            'https://images.unsplash.com/photo-1573865526739-10659fec78a5?auto=format&fit=crop&w=800&q=80',
        description:
            'Simba is a spunky calico kitten rescued in Salt Lake, Kolkata. Full of energy, loves climbing cat trees and cuddling at night. Fully dewormed and vaccinated.',
        shelterName: 'Kolkata Animal Rescue (KAR)',
        location: 'Salt Lake, Kolkata, WB',
        distance: '2.8 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Affectionate', 'Curious', 'Dewormed', 'Litter Trained'],
        vaccinations: [
          Vaccination(
            id: 'vac_simba_01',
            vaccineName: 'FVRCP Tricat Core',
            dateGiven: now.subtract(const Duration(days: 345)),
            nextDueDate: now.add(const Duration(days: 20)), // Due Soon (20 days)
            category: 'Core',
            notes: 'Annual tricat feline immunization booster.',
          ),
          Vaccination(
            id: 'vac_simba_02',
            vaccineName: 'Feline Anti-Rabies',
            dateGiven: now.subtract(const Duration(days: 120)),
            nextDueDate: now.add(const Duration(days: 245)),
            category: 'Core',
            notes: 'Rabies protection administered by clinic veterinarian.',
          ),
        ],
      ),
      Pet(
        id: 'pet_rocky_in_10',
        name: 'Rocky',
        breed: 'German Shepherd',
        age: '3.5 Years',
        gender: PetGender.male,
        category: PetCategory.dogs,
        image:
            'https://images.unsplash.com/photo-1589941013453-ec89f33b5455?auto=format&fit=crop&w=800&q=80',
        description:
            'Rocky is an intelligent, disciplined German Shepherd surrendered due to relocation. Highly trained, understands Hindi & English commands, and is a loyal protector.',
        shelterName: 'People For Animals (PFA)',
        location: 'Gachibowli, Hyderabad, TS',
        distance: '5.1 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Trained Guard Dog', 'High IQ', 'Loyal Protector', 'Microchipped'],
        vaccinations: [
          Vaccination(
            id: 'vac_rocky_01',
            vaccineName: '9-in-1 DHPPiL Annual Dose',
            dateGiven: now.subtract(const Duration(days: 220)),
            nextDueDate: now.add(const Duration(days: 145)),
            category: 'Core',
            notes: 'Complete multi-component canine vaccination dose.',
          ),
          Vaccination(
            id: 'vac_rocky_02',
            vaccineName: 'Anti-Rabies Mandatory Shot',
            dateGiven: now.subtract(const Duration(days: 185)),
            nextDueDate: now.add(const Duration(days: 180)),
            category: 'Core',
            notes: 'Administered at PFA Hyderabad veterinary dispensary.',
          ),
        ],
      ),
      Pet(
        id: 'pet_leo_in_11',
        name: 'Leo',
        breed: 'Beagle',
        age: '1 Year',
        gender: PetGender.male,
        category: PetCategory.dogs,
        image:
            'https://images.unsplash.com/photo-1505628346881-b72b27e84530?auto=format&fit=crop&w=800&q=80',
        description:
            'Leo is a joyful, energetic Beagle with floppy ears and a wagging tail. Rescued in Cyber Hub, loves food puzzles, sniffing adventures, and greeting guests cheerfully.',
        shelterName: 'STRAW India Rescue',
        location: 'Cyber City, Gurugram, HR',
        distance: '3.7 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Food Lover', 'Curious Explorer', 'Playful', 'Vaccinated'],
        vaccinations: [
          Vaccination(
            id: 'vac_leo_01',
            vaccineName: 'DHPP Core Vaccine',
            dateGiven: now.subtract(const Duration(days: 250)),
            nextDueDate: now.add(const Duration(days: 115)),
            category: 'Core',
            notes: 'Protects against Distemper, Hepatitis, Parvovirus.',
          ),
          Vaccination(
            id: 'vac_leo_02',
            vaccineName: 'Rabies Booster',
            dateGiven: now.subtract(const Duration(days: 75)),
            nextDueDate: now.add(const Duration(days: 290)),
            category: 'Core',
            notes: 'Annual rabies protection verified.',
          ),
        ],
      ),
      Pet(
        id: 'pet_mithu_in_12',
        name: 'Mithu',
        breed: 'Rescue Indian Ringneck Parakeet',
        age: '1 Year',
        gender: PetGender.male,
        category: PetCategory.others,
        image:
            'https://images.unsplash.com/photo-1552728089-57bdde30beb3?auto=format&fit=crop&w=800&q=80',
        description:
            'Mithu is a cheerful rescued green parakeet rehabilitated by avian specialists. He whistles melodious tunes, loves fresh guava and chillies, and enjoys gentle social interaction.',
        shelterName: 'PFA Avian Sanctuary',
        location: 'Bannerghatta, Bengaluru, KA',
        distance: '4.9 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Rehabilitated', 'Cheerful Whistler', 'Healthy', 'Special Care'],
        vaccinations: [
          Vaccination(
            id: 'vac_mithu_01',
            vaccineName: 'Avian Wellness & Parasite Screen',
            dateGiven: now.subtract(const Duration(days: 290)),
            nextDueDate: now.add(const Duration(days: 75)),
            category: 'Lifestyle / Non-Core',
            notes: 'Comprehensive avian veterinary checkup and feather screening.',
          ),
        ],
      ),
      Pet(
        id: 'pet_bunty_in_13',
        name: 'Bunty',
        breed: 'Indian Angora Mix Bunny',
        age: '8 Months',
        gender: PetGender.male,
        category: PetCategory.others,
        image:
            'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=800&q=80',
        description:
            'Bunty is a gentle, snow-white rescue rabbit who loves hopping on carpets, munching fresh palak & carrot tops, and being gently petted.',
        shelterName: 'RESQ Charitable Trust',
        location: 'Viman Nagar, Pune, MH',
        distance: '2.9 km',
        adoptionStatus: AdoptionStatus.available,
        tags: const ['Gentle & Calm', 'Indoor Bunny', 'Herbivore Diet', 'Dewormed'],
        vaccinations: [
          Vaccination(
            id: 'vac_bunty_01',
            vaccineName: 'RHDV Viral Immunization',
            dateGiven: now.subtract(const Duration(days: 200)),
            nextDueDate: now.add(const Duration(days: 165)),
            category: 'Core',
            notes: 'Rabbit Hemorrhagic Disease Virus vaccine administered.',
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
      if (category == PetCategory.others && pet.category != PetCategory.others) return false;

      // Search query filter
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        final matchName = pet.name.toLowerCase().contains(q);
        final matchBreed = pet.breed.toLowerCase().contains(q);
        final matchShelter = pet.shelterName.toLowerCase().contains(q);
        final matchLocation = pet.location.toLowerCase().contains(q);
        if (!matchName && !matchBreed && !matchShelter && !matchLocation) return false;
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
