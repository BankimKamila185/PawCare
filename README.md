# PawCare – Pet Adoption & Vaccination Reminder App

[![Flutter](https://img.shields.io/badge/Flutter-3.47.0-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.0-blue.svg)](https://dart.dev)
[![Material 3](https://img.shields.io/badge/Material-3-orange.svg)](https://m3.material.io)
[![Tests](https://img.shields.io/badge/Tests-15%2F15%20Passed-brightgreen.svg)]()
[![Offline](https://img.shields.io/badge/Offline-100%25%20Supported-success.svg)]()

PawCare is a production-quality, cross-platform Flutter application built for pet adoption and intelligent vaccination schedule tracking. The UI is crafted based on the **Google Stitch** Warm Pet Wellness design system.

---

## 📱 Features

- 🐾 **Pet Discovery & Adoption**: Browse available companion animals, filter by category (Dogs, Cats), search by breed/shelter, view complete profiles, and adopt with celebratory confetti animations.
- 💉 **Dynamic Vaccination Tracking**: Pure date-driven conditional logic calculates vaccination health in real-time:
  - 🟢 **UP TO DATE**: Due in >30 days
  - 🟡 **DUE SOON**: Due within 0 to 30 days
  - 🔴 **OVERDUE**: Past due date
- 🏥 **Clinical Vaccine Schedules**: Pre-configured with veterinary-approved schedules for Anti-Rabies (Mandatory Core), DHPP 7-in-1, Leptospirosis (Monsoon Protection), Bordetella (Kennel Cough), and FVRCP Tricat.
- 💾 **100% On-Device Local Persistence**: Fast, offline-first data management using structured JSON over `SharedPreferences`. No external cloud or backend required.
- 🏠 **Shelter Intake Portal**: List new rescue animals for adoption with custom tags, health profiles, and shelter distance.
- 🔔 **In-App Reminders & Alert Badges**: Real-time badge counters and alert cards for high-priority upcoming and overdue vaccinations.
- 🔐 **Local Authentication**: On-device registration, credential validation, and session management.

---

## 🏗️ Project Architecture

```
lib/
├── main.dart                                     # Application entry point & service providers
├── theme/
│   └── app_theme.dart                            # Centralized Stitch design tokens & M3 theme
├── models/
│   ├── enums.dart                                # AdoptionStatus, VaccinationStatus, PetGender, PetCategory
│   ├── user.dart                                 # User model with JSON serialization
│   ├── vaccination.dart                          # Vaccination record with ISO8601 parser
│   └── pet.dart                                  # Comprehensive Pet data model with history
├── utils/
│   └── vaccination_utils.dart                    # Pure dynamic Dart calculation for vaccine statuses
├── services/
│   ├── local_storage_service.dart                # On-device SharedPreferences structured JSON database
│   ├── auth_service.dart                         # Local authentication, registration & session manager
│   └── pet_service.dart                          # Pet catalog, adoption flow, vaccination records & metrics
├── widgets/
│   ├── app_header.dart                           # Top app bar with logo, notification badge & avatar
│   ├── status_badge.dart                         # Dynamic M3 status pills (Up to Date, Due Soon, Overdue)
│   ├── primary_button.dart                       # Primary gradient, secondary tonal, and outlined buttons
│   ├── custom_search_bar.dart                    # Live search bar with category filters
│   ├── pet_card.dart                             # 2-column discovery card & adopted companion card
│   ├── vaccination_card.dart                     # 4-grid metrics dashboard & timeline card
│   └── empty_state_view.dart                     # Empty state with actionable CTAs
└── screens/
    ├── splash/splash_screen.dart                 # Branded animated splash screen
    ├── welcome/welcome_screen.dart               # Hero welcome screen with value proposition
    ├── auth/
    │   ├── login_screen.dart                     # Local login with validation
    │   └── signup_screen.dart                    # Local account creation
    ├── main_navigation_screen.dart               # M3 bottom navigation (Home, My Pets, Vaccines, Profile)
    ├── home/home_screen.dart                     # Available pets catalog & search
    ├── pet_profile/pet_profile_screen.dart       # Full pet bio, stats, health badge & adoption modal
    ├── adoption/adoption_success_screen.dart     # Celebratory confetti adoption confirmation
    ├── my_pets/my_pets_screen.dart               # Adopted companions list
    ├── vaccinations/
    │   ├── vaccination_tracker_screen.dart       # 4-metric tracker & companion health list
    │   └── pet_vaccination_details_screen.dart   # Next vaccination countdown hero & timeline history
    ├── add_vaccination/add_vaccination_screen.dart# Form with quick-select chips, date pickers & save modal
    ├── reminders/vaccination_reminders_screen.dart# Clinical reminder alerts
    ├── shelter/shelter_add_pet_screen.dart       # Shelter intake form to list new animals
    └── profile/profile_screen.dart               # User profile, reminders shortcut & logout
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.13.0 or higher)

### Installation
```bash
# Clone the repository
git clone https://github.com/BankimKamila185/PawCare.git
cd PawCare

# Install dependencies
flutter pub get

# Run on Web (Chrome)
flutter run -d chrome

# Run on Android Emulator / Physical Device
flutter run
```

### Run Tests & Analyzer
```bash
# Analyze code
flutter analyze

# Run unit and widget test suites
flutter test
```

---

## 📄 License
This project was developed for academic and semester presentation purposes.
