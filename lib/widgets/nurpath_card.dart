import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NurPathCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final bool showBorder;
  final Color? borderColor;
  final VoidCallback? onTap;
  final double elevation;
  final List<BoxShadow>? boxShadow;

  const NurPathCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.backgroundColor,
    this.showBorder = true,
    this.borderColor,
    this.onTap,
    this.elevation = 0,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.bgCard,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(
                color: borderColor ?? AppColors.divider,
                width: 0.5,
              )
            : null,
        boxShadow: boxShadow ??
            (elevation > 0
                ? [
                    BoxShadow(
                      color: AppColors.shadowDark.withOpacity(0.4),
                      blurRadius: elevation * 4,
                      offset: Offset(0, elevation * 2),
                    )
                  ]
                : null),
      ),
      clipBehavior: Clip.antiAlias,
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.emerald.withOpacity(0.1),
          highlightColor: AppColors.emerald.withOpacity(0.05),
          child: card,
        ),
      );
    }

    return card;
  }
}

class GoldBorderCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const GoldBorderCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NurPathCard(
      padding: padding,
      borderRadius: borderRadius,
      borderColor: AppColors.gold.withOpacity(0.4),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowGold.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      onTap: onTap,
      child: child,
    );
  }
}

class EmeraldGradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const EmeraldGradientCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      decoration: BoxDecoration(
        gradient: AppColors.emeraldGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowEmerald.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
