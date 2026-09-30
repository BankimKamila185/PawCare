enum AdoptionStatus {
  available,
  adopted,
  pending;

  String get displayName {
    switch (this) {
      case AdoptionStatus.available:
        return 'Available';
      case AdoptionStatus.adopted:
        return 'Adopted';
      case AdoptionStatus.pending:
        return 'Pending';
    }
  }
}

enum VaccinationStatus {
  upToDate,
  dueSoon,
  overdue;

  String get displayName {
    switch (this) {
      case VaccinationStatus.upToDate:
        return 'Up to Date';
      case VaccinationStatus.dueSoon:
        return 'Due Soon';
      case VaccinationStatus.overdue:
        return 'Overdue';
    }
  }
}

enum PetGender {
  male,
  female;

  String get displayName {
    switch (this) {
      case PetGender.male:
        return 'Male';
      case PetGender.female:
        return 'Female';
    }
  }
}

enum PetCategory {
  all,
  dogs,
  cats,
  others;

  String get displayName {
    switch (this) {
      case PetCategory.all:
        return 'All';
      case PetCategory.dogs:
        return 'Dogs';
      case PetCategory.cats:
        return 'Cats';
      case PetCategory.others:
        return 'Others';
    }
  }
}
