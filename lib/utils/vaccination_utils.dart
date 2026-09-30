import 'package:intl/intl.dart';
import '../models/enums.dart';
import '../models/pet.dart';
import '../models/vaccination.dart';

class VaccinationUtils {
  /// Calculate the status of a single vaccination given its next due date.
  static VaccinationStatus calculateVaccinationStatus(DateTime nextDueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day);

    if (dueDate.isBefore(today)) {
      return VaccinationStatus.overdue;
    }

    final differenceInDays = dueDate.difference(today).inDays;
    if (differenceInDays <= 30) {
      return VaccinationStatus.dueSoon;
    }

    return VaccinationStatus.upToDate;
  }

  /// Calculate the overall vaccination status of a pet.
  /// If any vaccination is overdue -> overdue.
  /// Else if any vaccination is due soon -> dueSoon.
  /// Otherwise -> upToDate.
  static VaccinationStatus calculateOverallPetStatus(Pet pet) {
    if (pet.vaccinations.isEmpty) {
      return VaccinationStatus.upToDate;
    }

    bool hasDueSoon = false;
    for (final vac in pet.vaccinations) {
      final status = calculateVaccinationStatus(vac.nextDueDate);
      if (status == VaccinationStatus.overdue) {
        return VaccinationStatus.overdue;
      }
      if (status == VaccinationStatus.dueSoon) {
        hasDueSoon = true;
      }
    }

    if (hasDueSoon) {
      return VaccinationStatus.dueSoon;
    }

    return VaccinationStatus.upToDate;
  }

  /// Get the next upcoming vaccination for a pet (sorted by nextDueDate).
  static Vaccination? getNextUpcomingVaccination(Pet pet) {
    if (pet.vaccinations.isEmpty) return null;

    final sorted = List<Vaccination>.from(pet.vaccinations)
      ..sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));

    return sorted.first;
  }

  /// Calculate number of days remaining until due date (can be negative if overdue).
  static int calculateDaysRemaining(DateTime nextDueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day);
    return dueDate.difference(today).inDays;
  }

  /// Format date nicely: e.g. "12 October 2026" or "12 Oct 2026"
  static String formatDate(DateTime date, {bool short = false}) {
    if (short) {
      return DateFormat('d MMM yyyy').format(date);
    }
    return DateFormat('d MMMM yyyy').format(date);
  }

  /// Format month year: e.g. "October 2026"
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }
}
