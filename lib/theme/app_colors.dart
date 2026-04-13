import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette
  static const Color emerald = Color(0xFF0A6C5E);
  static const Color emeraldLight = Color(0xFF0E8A78);
  static const Color emeraldDark = Color(0xFF074E44);
  static const Color emeraldDeep = Color(0xFF053D35);

  // Gold Palette
  static const Color gold = Color(0xFFD4A017);
  static const Color goldLight = Color(0xFFE8B52A);
  static const Color goldDark = Color(0xFFAA7F0F);
  static const Color goldMuted = Color(0xFF8B6914);

  // Background Palette (Dark Mode Default)
  static const Color bgPrimary = Color(0xFF0D1F1C);
  static const Color bgSecondary = Color(0xFF122820);
  static const Color bgCard = Color(0xFF163028);
  static const Color bgCardElevated = Color(0xFF1A3830);
  static const Color bgSurface = Color(0xFF1E4035);
  static const Color bgOverlay = Color(0xFF0A1A17);

  // Text Colors
  static const Color textPrimary = Color(0xFFEFF6F4);
  static const Color textSecondary = Color(0xFFAAC4BE);
  static const Color textMuted = Color(0xFF6B9990);
  static const Color textDisabled = Color(0xFF4A7068);
  static const Color textOnGold = Color(0xFF1A1000);
  static const Color textArabic = Color(0xFFF5F0E8);

  // Semantic Colors
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  // Ring/Score Colors
  static const Color ringQuran = Color(0xFF0A6C5E);
  static const Color ringHeart = Color(0xFFD4A017);
  static const Color ringSalah = Color(0xFF1ABC9C);
  static const Color ringKindness = Color(0xFFE67E22);
  static const Color ringScore = Color(0xFFD4A017);

  // Geometric Pattern Colors
  static const Color patternLight = Color(0x0AFFFFFF);
  static const Color patternDark = Color(0x05FFFFFF);

  // Divider
  static const Color divider = Color(0xFF1E4035);
  static const Color dividerLight = Color(0xFF2A5045);

  // Shadow
  static const Color shadowEmerald = Color(0x400A6C5E);
  static const Color shadowGold = Color(0x40D4A017);
  static const Color shadowDark = Color(0x800D1F1C);

  // Gradients
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgPrimary, bgSecondary, bgCard],
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [emerald, emeraldDark],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, gold, goldDark],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgCard, bgCardElevated],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [emerald, emeraldDeep, bgPrimary],
  );

  // Light Mode Colors (for potential future use)
  static const Color bgPrimaryLight = Color(0xFFF0FAF8);
  static const Color bgSecondaryLight = Color(0xFFE8F5F2);
  static const Color textPrimaryLight = Color(0xFF0D1F1C);
}
