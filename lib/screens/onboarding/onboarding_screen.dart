import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/geometric_pattern.dart';
import '../../services/db_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _name = '';
  String _goal = '';
  int _dailyAyahGoal = 5;
  bool _bismillah = true;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  final List<_OnboardingPage> _pages = [
    const _OnboardingPage(
      icon: '🌙',
      title: 'Bismillah\nAr-Rahman Ar-Rahim',
      subtitle:
          'Welcome to NurPath — your companion for Quran learning, reflection, and spiritual growth.',
      isIntro: true,
    ),
    const _OnboardingPage(
      icon: '📖',
      title: 'Learn the Quran\nat your own pace',
      subtitle:
          'Read with translations, word-by-word breakdown, and listen to beautiful recitations from renowned Qaris.',
    ),
    const _OnboardingPage(
      icon: '💭',
      title: 'Reflect &\nGrow Spiritually',
      subtitle:
          'AI-assisted reflection prompts rooted in authentic Tafseer help you connect Quranic wisdom to daily life.',
    ),
    const _OnboardingPage(
      icon: '⭐',
      title: 'Track Your\nFaith Journey',
      subtitle:
          'Your personal Faith Score tracks Quran engagement, heart reflection, salah alignment, and acts of kindness.',
    ),
    const _OnboardingPage(
      icon: '🤲',
      title: "What's your\nname?",
      subtitle: 'May Allah bless your journey.',
      isNameInput: true,
    ),
    const _OnboardingPage(
      icon: '🎯',
      title: 'Set your\ndaily goal',
      subtitle: 'How many ayahs would you like to read each day?',
      isGoalInput: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      _fadeController.reset();
      await _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      _fadeController.forward();
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    final user = await DbService.instance.getUser();
    if (user != null) {
      user
        ..name = _name.isEmpty ? 'Friend' : _name
        ..dailyAyahGoal = _dailyAyahGoal
        ..bismillahOption = _bismillah
        ..onboardingComplete = true;
      await DbService.instance.saveUser(user);
    }
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: GeometricPatternBackground(
        opacity: 0.03,
        child: SafeArea(
          child: Column(
            children: [
              // Progress dots
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _currentPage ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _currentPage
                            ? AppColors.gold
                            : AppColors.divider,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildPage(_pages[index]),
                    );
                  },
                ),
              ),

              // CTA Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isLast ? 'Begin My Journey' : 'Continue',
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji / Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.emerald.withOpacity(0.15),
              border: Border.all(
                color: AppColors.emerald.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                page.icon,
                style: const TextStyle(fontSize: 44),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Title
          Text(
            page.title,
            style: page.isIntro
                ? AppTypography.goldHeadline.copyWith(
                    fontSize: 26,
                    fontFamily: 'Amiri',
                  )
                : AppTypography.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            page.subtitle,
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Special inputs
          if (page.isNameInput) _buildNameInput(),
          if (page.isGoalInput) _buildGoalInput(),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return TextField(
      onChanged: (v) => setState(() => _name = v),
      style: AppTypography.bodyLarge,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'Your name...',
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textDisabled,
        ),
        filled: true,
        fillColor: AppColors.bgCardElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.emerald, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildGoalInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [3, 5, 10, 20].map((g) {
            final isSelected = _dailyAyahGoal == g;
            return GestureDetector(
              onTap: () => setState(() => _dailyAyahGoal = g),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.emerald
                      : AppColors.bgCardElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.emerald : AppColors.divider,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.shadowEmerald.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$g',
                      style: AppTypography.headlineLarge.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'ayahs',
                      style: AppTypography.labelSmall.copyWith(
                        color: isSelected ? Colors.white70 : AppColors.textMuted,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        // Bismillah toggle
        Row(
          children: [
            Expanded(
              child: Text(
                'Show Bismillah before each Surah',
                style: AppTypography.bodyMedium,
              ),
            ),
            Switch(
              value: _bismillah,
              onChanged: (v) => setState(() => _bismillah = v),
              activeColor: AppColors.emerald,
            ),
          ],
        ),
      ],
    );
  }
}

class _OnboardingPage {
  final String icon;
  final String title;
  final String subtitle;
  final bool isIntro;
  final bool isNameInput;
  final bool isGoalInput;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isIntro = false,
    this.isNameInput = false,
    this.isGoalInput = false,
  });
}
