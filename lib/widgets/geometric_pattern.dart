import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';

/// Renders a subtle Islamic geometric star/arabesque pattern as a background
class GeometricPatternPainter extends CustomPainter {
  final Color color;
  final double opacity;

  GeometricPatternPainter({
    this.color = AppColors.patternLight,
    this.opacity = 0.04,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    const spacing = 60.0;
    final cols = (size.width / spacing).ceil() + 2;
    final rows = (size.height / spacing).ceil() + 2;

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final cx = col * spacing + (row.isOdd ? spacing / 2 : 0);
        final cy = row * spacing * 0.866;
        _drawStar(canvas, Offset(cx, cy), 18, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 8;
    const innerRatio = 0.45;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) - math.pi / 2;
      final r = i.isEven ? radius : radius * innerRatio;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // Inner circle detail
    canvas.drawCircle(center, radius * 0.2, paint);
  }

  @override
  bool shouldRepaint(GeometricPatternPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.opacity != opacity;
}

class GeometricPatternBackground extends StatelessWidget {
  final Widget child;
  final double opacity;
  final Color? color;

  const GeometricPatternBackground({
    super.key,
    required this.child,
    this.opacity = 0.04,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: GeometricPatternPainter(
              color: color ?? AppColors.patternLight,
              opacity: opacity,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
