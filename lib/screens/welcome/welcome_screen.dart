import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Brand Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.pets_rounded,
                      color: AppColors.onPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'PawCare',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Hero Image with curved container & ambient shadow
              Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAZaNYhpcLX-1zVFpzTQ2f9RqI6WLFkgRDIPcOcoF84_aRvBguBk7irYZZ1JiS2E1cNBnDsnIOstU_vK6XLvycugCL1IhbnKzJz-fLTkz6QhCaV-y_KO9C16p44eQiyuLbEivv5QqyFJD-E0HAPj9c5wFdh5bkatThFVC-k4ILpoiPp8RAASPNPR96m2UFpt1hS9ezlW7Bk7xsZ91WzZx5VLtdcdmZ8u40YNd-yqF-z6opKg5AcJMES',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primaryFixed,
                      child: const Center(
                        child: Icon(Icons.pets, size: 80, color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Content & Value Proposition
              Column(
                children: [
                  const Text(
                    'Compassionate Pet Care & Adoption',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                      color: AppColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Find your forever companion and keep them protected with timely vaccination reminders.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Feature pills
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeatureChip(Icons.volunteer_activism_rounded, 'Adopt'),
                      const SizedBox(width: 8),
                      _buildFeatureChip(Icons.vaccines_rounded, 'Track Vaccines'),
                      const SizedBox(width: 8),
                      _buildFeatureChip(Icons.alarm_rounded, 'Reminders'),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Action Buttons
              Column(
                children: [
                  PrimaryButton(
                    label: 'Get Started',
                    trailingIcon: Icons.arrow_forward_rounded,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'I already have an account',
                    variant: ButtonVariant.outlined,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
