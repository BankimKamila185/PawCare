import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/pet.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../main_navigation_screen.dart';

class AdoptionSuccessScreen extends StatefulWidget {
  final Pet pet;

  const AdoptionSuccessScreen({super.key, required this.pet});

  @override
  State<AdoptionSuccessScreen> createState() => _AdoptionSuccessScreenState();
}

class _AdoptionSuccessScreenState extends State<AdoptionSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _badgeController;
  late AnimationController _contentController;
  late AnimationController _confettiController;
  late AnimationController _pulseController;

  late Animation<double> _badgeScale;
  late Animation<double> _badgeRotate;
  late Animation<double> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<double> _cardSlide;
  late Animation<double> _cardFade;
  late Animation<double> _buttonSlide;
  late Animation<double> _buttonFade;

  late List<_ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();

    // 1. Badge pop-in spring controller
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _badgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _badgeController,
        curve: Curves.elasticOut,
      ),
    );

    _badgeRotate = Tween<double>(begin: -0.15, end: 0.0).animate(
      CurvedAnimation(
        parent: _badgeController,
        curve: Curves.easeOutBack,
      ),
    );

    // 2. Continuous ambient pulse for the badge glow
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // 3. Staggered text & card content entrance
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _titleSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeIn),
      ),
    );

    _cardSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
      ),
    );
    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    _buttonSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.5, 0.9, curve: Curves.easeIn),
      ),
    );

    // 4. Confetti physics controller
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _generateConfetti();

    // Sequence the animations
    _badgeController.forward();
    _confettiController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _contentController.forward();
    });
  }

  void _generateConfetti() {
    final random = math.Random();
    const colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiary,
      Color(0xFFEC4899),
      Color(0xFF8B5CF6),
      Color(0xFF3B82F6),
      Color(0xFFFBBF24),
    ];

    _particles = List.generate(45, (index) {
      final angle = random.nextDouble() * 2 * math.pi;
      final speed = 120.0 + random.nextDouble() * 260.0;
      final size = 6.0 + random.nextDouble() * 8.0;
      final color = colors[random.nextInt(colors.length)];
      final rotationSpeed = (random.nextDouble() - 0.5) * 6;
      final isCircle = random.nextBool();

      return _ConfettiParticle(
        angle: angle,
        speed: speed,
        size: size,
        color: color,
        rotationSpeed: rotationSpeed,
        isCircle: isCircle,
      );
    });
  }

  void _triggerExtraBurst() {
    _generateConfetti();
    _badgeController.forward(from: 0.6);
    _confettiController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _badgeController.dispose();
    _contentController.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Confetti Animation Canvas Overlay
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _confettiController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _ConfettiPainter(
                    progress: _confettiController.value,
                    particles: _particles,
                  ),
                );
              },
            ),
          ),

          // Main Screen Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 10),

                  // Celebration Center Block
                  Column(
                    children: [
                      // Animated Celebration Badge with Ripple Glow & Tap Reaction
                      GestureDetector(
                        onTap: _triggerExtraBurst,
                        child: AnimatedBuilder(
                          animation: Listenable.merge([_badgeController, _pulseController]),
                          builder: (context, child) {
                            final pulse = 1.0 + (_pulseController.value * 0.08);
                            return Transform.scale(
                              scale: _badgeScale.value * pulse,
                              child: Transform.rotate(
                                angle: _badgeRotate.value,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Ambient glowing ripple ring
                                    Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.secondary
                                            .withValues(alpha: 0.12 * (1.0 - _pulseController.value)),
                                      ),
                                    ),
                                    // Core Badge
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryContainer,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.secondary
                                                .withValues(alpha: 0.28 + (_pulseController.value * 0.15)),
                                            blurRadius: 24,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.celebration_rounded,
                                          size: 46,
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Animated Headlines & Descriptions
                      AnimatedBuilder(
                        animation: _contentController,
                        builder: (context, _) {
                          return Transform.translate(
                            offset: Offset(0, _titleSlide.value),
                            child: Opacity(
                              opacity: _titleFade.value,
                              child: Column(
                                children: [
                                  const Text(
                                    'Congratulations!',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.onSurface,
                                      letterSpacing: -0.6,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${widget.pet.name} is now part of your family.',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'Their health profile and immunization schedule have been linked to your Vaccination Tracker.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.onSurfaceVariant,
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 28),

                      // Animated Pet Summary Card
                      AnimatedBuilder(
                        animation: _contentController,
                        builder: (context, _) {
                          return Transform.translate(
                            offset: Offset(0, _cardSlide.value),
                            child: Opacity(
                              opacity: _cardFade.value,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1E293B).withValues(alpha: 0.06),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: SizedBox(
                                            width: 68,
                                            height: 68,
                                            child: Image.network(
                                              widget.pet.image,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                color: AppColors.surfaceContainerHigh,
                                                child: const Icon(Icons.pets, color: AppColors.primary),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Floating celebratory heart badge
                                        Positioned(
                                          top: -4,
                                          right: -4,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFEC4899),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.favorite_rounded,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.pet.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.onSurface,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${widget.pet.breed} • ${widget.pet.age}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.onSurfaceVariant,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryFixed,
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_rounded,
                                                  size: 12,
                                                  color: AppColors.onSecondaryFixedVariant,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Vaccine Profile Active',
                                                  style: TextStyle(
                                                    fontSize: 10.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.onSecondaryFixedVariant,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // Animated Action Buttons
                  AnimatedBuilder(
                    animation: _contentController,
                    builder: (context, _) {
                      return Transform.translate(
                        offset: Offset(0, _buttonSlide.value),
                        child: Opacity(
                          opacity: _buttonFade.value,
                          child: Column(
                            children: [
                              PrimaryButton(
                                label: 'Go to My Pets',
                                trailingIcon: Icons.pets_rounded,
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MainNavigationScreen(initialIndex: 1),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              PrimaryButton(
                                label: 'View Vaccination Tracker',
                                variant: ButtonVariant.outlined,
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MainNavigationScreen(initialIndex: 2),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== CONFETTI PARTICLES ====================

class _ConfettiParticle {
  final double angle;
  final double speed;
  final double size;
  final Color color;
  final double rotationSpeed;
  final bool isCircle;

  _ConfettiParticle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
    required this.rotationSpeed,
    required this.isCircle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<_ConfettiParticle> particles;

  _ConfettiPainter({required this.progress, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0.0 || progress == 1.0) return;

    final centerX = size.width / 2;
    final centerY = size.height * 0.22; // Centered around the celebration badge
    final gravity = 220.0 * progress * progress;
    final fade = math.sin(progress * math.pi);

    for (final particle in particles) {
      final distance = particle.speed * progress;
      final x = centerX + math.cos(particle.angle) * distance;
      final y = centerY + math.sin(particle.angle) * distance + gravity;

      final paint = Paint()
        ..color = particle.color.withValues(alpha: (0.9 * fade).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotationSpeed * progress * math.pi * 2);

      if (particle.isCircle) {
        canvas.drawCircle(Offset.zero, particle.size / 2, paint);
      } else {
        final rect = Rect.fromCenter(
          center: Offset.zero,
          width: particle.size * 1.4,
          height: particle.size * 0.7,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
