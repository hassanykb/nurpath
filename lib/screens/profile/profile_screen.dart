import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/app_providers.dart';
import '../../models/user_model.dart';
import '../../services/db_service.dart';
import '../../widgets/geometric_pattern.dart';
import '../../widgets/nurpath_card.dart';
import '../../widgets/streak_badge.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: GeometricPatternBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── AppBar ─────────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.bgPrimary,
                leading: const BackButton(color: AppColors.textPrimary),
                title: Text('Profile / Me', style: AppTypography.headlineMedium),
                actions: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary),
                    color: AppColors.bgCard,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit_name':
                          _showEditNameDialog(
                              context, ref, userAsync.valueOrNull);
                          break;
                        case 'sign_out':
                          _showSignOutDialog(context);
                          break;
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit_name',
                        child: Row(
                          children: [
                            const Icon(Icons.edit_rounded,
                                size: 16, color: AppColors.textMuted),
                            const SizedBox(width: 8),
                            Text('Edit Name', style: AppTypography.bodyMedium),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'sign_out',
                        child: Row(
                          children: [
                            const Icon(Icons.logout_rounded,
                                size: 16, color: AppColors.textMuted),
                            const SizedBox(width: 8),
                            Text('Sign Out', style: AppTypography.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // ── Profile Header ──────────────────────────────
              SliverToBoxAdapter(
                child: userAsync.when(
                  data: (user) => _ProfileHeader(user: user),
                  loading: () => const SizedBox(height: 120),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Growth Goals ───────────────────────────
                    userAsync.when(
                      data: (user) =>
                          _GrowthGoalsCard(user: user, ref: ref),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),

                    // ── Streak History ────────────────────────
                    _StreakHistoryCard(),
                    const SizedBox(height: 16),

                    // ── Family Sharing ─────────────────────────
                    const _FamilySharingCard(),
                    const SizedBox(height: 16),

                    // ── Settings ──────────────────────────────
                    userAsync.when(
                      data: (user) =>
                          _SettingsSection(user: user, ref: ref),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditNameDialog(
      BuildContext context, WidgetRef ref, UserProfile? user) {
    final nameCtrl =
        TextEditingController(text: user?.name ?? '');
    final lastCtrl =
        TextEditingController(text: user?.lastName ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:
            Text('Edit Name', style: AppTypography.headlineSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: AppTypography.bodySmall,
                filled: true,
                fillColor: AppColors.bgCardElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lastCtrl,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Last Name (optional)',
                labelStyle: AppTypography.bodySmall,
                filled: true,
                fillColor: AppColors.bgCardElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppTypography.labelMedium
                    .copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () async {
              final u = user;
              if (u != null && nameCtrl.text.trim().isNotEmpty) {
                u.name = nameCtrl.text.trim();
                u.lastName = lastCtrl.text.trim().isEmpty
                    ? null
                    : lastCtrl.text.trim();
                await DbService.instance.saveUser(u);
                ref.invalidate(userProfileProvider);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text('Save',
                style: AppTypography.labelMedium
                    .copyWith(color: AppColors.gold)),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Sign Out', style: AppTypography.headlineSmall),
        content: Text(
            'Your progress and journal entries are saved locally.',
            style: AppTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style:
                    AppTypography.labelMedium.copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/home');
            },
            child: Text('Sign Out',
                style: AppTypography.labelMedium
                    .copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserProfile? user;

  const _ProfileHeader({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Moon icon / avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF3A3A5C), Color(0xFF1A1A3C)],
              ),
              border: Border.all(
                color: AppColors.gold.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Text('🌙', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTypography.displaySmall.copyWith(
                      fontFamily: 'Amiri',
                      color: AppColors.gold,
                    ),
                    children: [
                      TextSpan(text: user?.name ?? 'Hassan'),
                    ],
                  ),
                ),
                if (user?.lastName != null)
                  Text(
                    user!.lastName!,
                    style: AppTypography.bodyMedium,
                  ),
              ],
            ),
          ),
          // Faith Score badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider, width: 0.5),
            ),
            child: Column(
              children: [
                Text(
                  'Faith Score',
                  style: AppTypography.labelSmall.copyWith(fontSize: 9),
                ),
                Text(
                  '${user?.faithScore ?? 0}/100',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthGoalsCard extends StatelessWidget {
  final UserProfile? user;
  final WidgetRef ref;

  const _GrowthGoalsCard({this.user, required this.ref});

  @override
  Widget build(BuildContext context) {
    return NurPathCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('My Growth Goals', style: AppTypography.headlineSmall),
              const Spacer(),
              const Icon(Icons.chevron_right,
                  color: AppColors.textMuted, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _GoalChip(
                label: 'Daily ${user?.dailyAyahGoal ?? 5} ayahs',
                isActive: true,
              ),
              _GoalChip(
                  label: 'Deep study',
                  isActive: user?.deepStudyGoal ?? false),
              _GoalChip(
                  label: 'Nightly reflection',
                  isActive: user?.nightlyReflectionGoal ?? true),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.bgCardElevated,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Nightly reflection',
                    style: AppTypography.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.bgCardElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.edit_rounded,
                    color: AppColors.textMuted, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: const SliderThemeData(
              trackHeight: 3,
              thumbShape:
                  RoundSliderThumbShape(enabledThumbRadius: 0),
              overlayShape:
                  RoundSliderOverlayShape(overlayRadius: 0),
            ),
            child: Slider(
              value: 0.75,
              onChanged: (_) {},
              activeColor: AppColors.emerald,
              inactiveColor: AppColors.divider,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () =>
                  _showEditGoalsSheet(context, ref, user),
              child: Text(
                'Edit',
                style: AppTypography.labelMedium
                    .copyWith(color: AppColors.gold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditGoalsSheet(
      BuildContext context, WidgetRef ref, UserProfile? user) {
    if (user == null) return;
    int ayahGoal = user.dailyAyahGoal;
    bool nightly = user.nightlyReflectionGoal;
    bool deepStudy = user.deepStudyGoal;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Growth Goals',
                  style: AppTypography.headlineMedium),
              const SizedBox(height: 24),

              // Daily ayah goal
              Text('Daily Ayah Goal: $ayahGoal',
                  style: AppTypography.bodyMedium),
              Slider(
                value: ayahGoal.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                activeColor: AppColors.gold,
                inactiveColor: AppColors.divider,
                label: '$ayahGoal',
                onChanged: (v) =>
                    setModalState(() => ayahGoal = v.round()),
              ),
              const SizedBox(height: 12),

              // Nightly reflection
              Row(
                children: [
                  Expanded(
                    child: Text('Nightly Reflection',
                        style: AppTypography.bodyMedium),
                  ),
                  Switch(
                    value: nightly,
                    onChanged: (v) =>
                        setModalState(() => nightly = v),
                    activeColor: AppColors.emerald,
                  ),
                ],
              ),

              // Deep study
              Row(
                children: [
                  Expanded(
                    child: Text('Deep Study Mode',
                        style: AppTypography.bodyMedium),
                  ),
                  Switch(
                    value: deepStudy,
                    onChanged: (v) =>
                        setModalState(() => deepStudy = v),
                    activeColor: AppColors.emerald,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    user.dailyAyahGoal = ayahGoal;
                    user.nightlyReflectionGoal = nightly;
                    user.deepStudyGoal = deepStudy;
                    await DbService.instance.saveUser(user);
                    ref.invalidate(userProfileProvider);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Goals'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _GoalChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.emerald.withOpacity(0.15)
            : AppColors.bgCardElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? AppColors.emerald.withOpacity(0.4)
              : AppColors.divider,
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color:
              isActive ? AppColors.emerald : AppColors.textMuted,
        ),
      ),
    );
  }
}

class _StreakHistoryCard extends StatelessWidget {
  final List<bool> _week = const [
    true, true, true, true, true, true, true
  ];
  final List<String> _days = const [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  _StreakHistoryCard();

  @override
  Widget build(BuildContext context) {
    return NurPathCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Streak History',
                  style: AppTypography.headlineSmall),
              const Spacer(),
              const Icon(Icons.chevron_right,
                  color: AppColors.textMuted, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              return Column(
                children: [
                  Text(
                    _days[i].substring(0, 2),
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 9,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _week[i] ? '🔥' : '⬜',
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FamilySharingCard extends StatelessWidget {
  const _FamilySharingCard();

  @override
  Widget build(BuildContext context) {
    return NurPathCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Family Sharing',
                  style: AppTypography.headlineSmall),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.gold.withOpacity(0.4),
                      width: 1),
                ),
                child: Text(
                  'Invite Family',
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.gold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _FamilyMember(emoji: '👧', name: 'Sample Kid'),
              const SizedBox(width: 12),
              _FamilyMember(emoji: '👦', name: 'Sample Kid'),
              const SizedBox(width: 12),
              _FamilyMember(emoji: '👧', name: 'Sample Kid'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FamilyMember extends StatelessWidget {
  final String emoji;
  final String name;

  const _FamilyMember({required this.emoji, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.bgCardElevated,
            border:
                Border.all(color: AppColors.divider, width: 0.5),
          ),
          child: Center(
            child:
                Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: AppTypography.labelSmall.copyWith(fontSize: 9),
        ),
      ],
    );
  }
}

class _SettingsSection extends StatefulWidget {
  final UserProfile? user;
  final WidgetRef ref;

  const _SettingsSection({this.user, required this.ref});

  @override
  State<_SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<_SettingsSection> {
  bool _offlineMode = true;
  String _language = 'Arabic';

  @override
  void initState() {
    super.initState();
    _offlineMode = widget.user?.offlineMode ?? true;
    _language =
        widget.user?.language == 'ar' ? 'Arabic' : 'English';
  }

  @override
  Widget build(BuildContext context) {
    return NurPathCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: AppTypography.headlineSmall),
          const SizedBox(height: 12),

          // Notification Preferences
          _SettingsTile(
            label: 'Notification Preferences',
            trailing: const Icon(Icons.chevron_right,
                color: AppColors.textMuted, size: 20),
            onTap: () => _showNotificationPrefs(context),
          ),
          const SizedBox(height: 1),
          Container(height: 0.5, color: AppColors.divider),
          const SizedBox(height: 1),

          // Offline Mode
          Row(
            children: [
              Expanded(
                child: Text('Offline Mode',
                    style: AppTypography.bodyMedium),
              ),
              Switch(
                value: _offlineMode,
                onChanged: (v) async {
                  setState(() => _offlineMode = v);
                  final user = widget.user;
                  if (user != null) {
                    user.offlineMode = v;
                    await DbService.instance.saveUser(user);
                    widget.ref.invalidate(userProfileProvider);
                  }
                },
                activeColor: AppColors.emerald,
              ),
            ],
          ),
          Container(height: 0.5, color: AppColors.divider),

          // Language
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Language',
                    style: AppTypography.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  children:
                      ['English', 'Arabic', 'Ghanaian'].map((lang) {
                    final isSelected = lang == _language;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _language = lang),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.bgCardElevated,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: Text(
                            lang,
                            style:
                                AppTypography.labelMedium.copyWith(
                              color: isSelected
                                  ? AppColors.textOnGold
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Container(height: 0.5, color: AppColors.divider),

          // Export Journal
          _SettingsTile(
            label: 'Export Journal',
            trailing: const Icon(Icons.chevron_right,
                color: AppColors.textMuted, size: 20),
            onTap: () => _exportJournal(context),
          ),
        ],
      ),
    );
  }

  void _showNotificationPrefs(BuildContext context) {
    bool dailyAyah = true;
    bool nightlyReminder = widget.user?.nightlyReflectionGoal ?? true;
    bool streakReminder = true;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notification Preferences',
                  style: AppTypography.headlineMedium),
              const SizedBox(height: 20),

              _NotifRow(
                label: 'Daily Ayah Reminder',
                subtitle: 'Morning reminder to read your daily ayah',
                value: dailyAyah,
                onChanged: (v) =>
                    setModalState(() => dailyAyah = v),
              ),
              const Divider(color: AppColors.divider, height: 1),
              _NotifRow(
                label: 'Nightly Reflection',
                subtitle: 'Evening prompt to journal and reflect',
                value: nightlyReminder,
                onChanged: (v) =>
                    setModalState(() => nightlyReminder = v),
              ),
              const Divider(color: AppColors.divider, height: 1),
              _NotifRow(
                label: 'Streak Reminders',
                subtitle: "Don't lose your streak",
                value: streakReminder,
                onChanged: (v) =>
                    setModalState(() => streakReminder = v),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final user = widget.user;
                    if (user != null) {
                      user.nightlyReflectionGoal = nightlyReminder;
                      await DbService.instance.saveUser(user);
                      widget.ref.invalidate(userProfileProvider);
                    }
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Notification preferences saved',
                              style: AppTypography.bodyMedium),
                          backgroundColor: AppColors.bgCardElevated,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Preferences'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportJournal(BuildContext context) async {
    final entries = await DbService.instance.getJournalEntries(limit: 100);
    if (entries.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No journal entries to export',
              style: AppTypography.bodyMedium),
          backgroundColor: AppColors.bgCardElevated,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final buffer = StringBuffer();
    buffer.writeln('NurPath Journal Export');
    buffer.writeln('=' * 40);
    buffer.writeln();

    for (final e in entries) {
      final date =
          '${months[e.createdAt.month - 1]} ${e.createdAt.day}, ${e.createdAt.year}';
      buffer.writeln('Date: $date');
      if (e.surahRef != null) buffer.writeln('Ayah: ${e.surahRef}');
      if (e.prompt.isNotEmpty) buffer.writeln('Prompt: ${e.prompt}');
      buffer.writeln();
      buffer.writeln(e.content);
      if (e.linkedDeed != null) buffer.writeln('[Deed: ${e.linkedDeed}]');
      buffer.writeln('-' * 40);
      buffer.writeln();
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${entries.length} entries copied to clipboard',
            style: AppTypography.bodyMedium),
        backgroundColor: AppColors.bgCardElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _NotifRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.bodyMedium),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.emerald,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: AppTypography.bodyMedium),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
