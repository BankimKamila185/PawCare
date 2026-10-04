import 'enums.dart';
import 'vaccination.dart';

class Pet {
  final String id;
  final String name;
  final String breed;
  final String age;
  final PetGender gender;
  final PetCategory category;
  final String image;
  final String description;
  final String shelterName;
  final String location;
  final String distance;
  final AdoptionStatus adoptionStatus;
  final bool isFavorite;
  final List<String> tags;
  final List<Vaccination> vaccinations;

  const Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.category,
    required this.image,
    required this.description,
    this.shelterName = 'CUPA Rescue Center',
    this.location = 'Bengaluru, KA',
    this.distance = '2.4 km',
    this.adoptionStatus = AdoptionStatus.available,
    this.isFavorite = false,
    this.tags = const ['Good with Children', 'Pet Friendly'],
    this.vaccinations = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
      'gender': gender.name,
      'category': category.name,
      'image': image,
      'description': description,
      'shelterName': shelterName,
      'location': location,
      'distance': distance,
      'adoptionStatus': adoptionStatus.name,
      'isFavorite': isFavorite,
      'tags': tags,
      'vaccinations': vaccinations.map((v) => v.toJson()).toList(),
    };
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      breed: json['breed'] as String? ?? '',
      age: json['age'] as String? ?? '',
      gender: PetGender.values.firstWhere(
        (e) => e.name == json['gender'],
        orElse: () => PetGender.male,
      ),
      category: PetCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => PetCategory.dogs,
      ),
      image: json['image'] as String? ?? '',
      description: json['description'] as String? ?? '',
      shelterName: json['shelterName'] as String? ?? 'CUPA Rescue Center',
      location: json['location'] as String? ?? 'Bengaluru, KA',
      distance: json['distance'] as String? ?? '2.4 km',
      adoptionStatus: AdoptionStatus.values.firstWhere(
        (e) => e.name == json['adoptionStatus'],
        orElse: () => AdoptionStatus.available,
      ),
      isFavorite: json['isFavorite'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          ['Good with Children', 'Pet Friendly'],
      vaccinations: (json['vaccinations'] as List<dynamic>?)
              ?.map((e) => Vaccination.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Pet copyWith({
    String? id,
    String? name,
    String? breed,
    String? age,
    PetGender? gender,
    PetCategory? category,
    String? image,
    String? description,
    String? shelterName,
    String? location,
    String? distance,
    AdoptionStatus? adoptionStatus,
    bool? isFavorite,
    List<String>? tags,
    List<Vaccination>? vaccinations,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      category: category ?? this.category,
      image: image ?? this.image,
      description: description ?? this.description,
      shelterName: shelterName ?? this.shelterName,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      adoptionStatus: adoptionStatus ?? this.adoptionStatus,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      vaccinations: vaccinations ?? this.vaccinations,
    );
  }
}
