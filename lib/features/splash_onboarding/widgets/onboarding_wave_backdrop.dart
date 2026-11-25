import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Latar split-canvas organik bergaya design referensi .jpg dalam palet hijau
/// TeraNusa dengan proporsi halus dan tenang (tidak berlebihan): panggung atas
/// sage lembut, 2 lapis bukit lembut, gelombang putih halus, dan 1 aksen grid.
class OnboardingWaveBackdrop extends StatelessWidget {
  final double pageOffset;

  const OnboardingWaveBackdrop({super.key, required this.pageOffset});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _OnboardingWavePainter(pageOffset: pageOffset),
      ),
    );
  }
}

class _OnboardingWavePainter extends CustomPainter {
  final double pageOffset;

  const _OnboardingWavePainter({required this.pageOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final splitY = h * 0.49;
    final clamped = pageOffset.clamp(0.0, 2.0);

    // 1. Latar atas sage lembut
    final topRect = Rect.fromLTWH(0, 0, w, splitY + 60);
    final topPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFEBF6EC), Color(0xFFF6FBF6)],
      ).createShader(topRect);
    canvas.drawRect(topRect, topPaint);

    // 2. Satu aksen micro dot-grid halus di pojok kiri atas
    _drawDotGrid(
      canvas,
      origin: Offset(w * 0.08, h * 0.09),
      rows: 4,
      cols: 5,
      spacing: 11,
      color: AppColors.primary.withValues(alpha: 0.06),
    );

    // 3. Dua lapis siluet bukit hijau lembut dengan parallax tipis
    _drawHillLayer(
      canvas,
      size: size,
      baseY: splitY - 16,
      shiftX: -clamped * w * 0.08,
      amplitude: 16,
      color: const Color(0xFFAEDBB0),
    );
    _drawHillLayer(
      canvas,
      size: size,
      baseY: splitY - 4,
      shiftX: -clamped * w * 0.14 + 22,
      amplitude: 13,
      color: AppColors.primary.withValues(alpha: 0.84),
    );

    // 4. Kurva gelombang putih halus yang morph lembut antar 3 slide
    final wavePath = _buildGentleWavePath(w, h, splitY, clamped);
    canvas.drawPath(wavePath, Paint()..color = AppColors.white);
  }

  void _drawHillLayer(
    Canvas canvas, {
    required Size size,
    required double baseY,
    required double shiftX,
    required double amplitude,
    required Color color,
  }) {
    final w = size.width;
    final h = size.height;
    final path = Path()..moveTo(0, h);
    path.lineTo(0, baseY);

    const segments = 4;
    final segW = (w * 1.35) / segments;
    final startX = shiftX - w * 0.12;

    path.lineTo(startX, baseY);
    for (var i = 0; i < segments + 2; i++) {
      final x0 = startX + i * segW;
      final xMid = x0 + segW * 0.5;
      final x1 = x0 + segW;
      final crest = i.isEven ? amplitude : amplitude * 0.72;
      path.quadraticBezierTo(xMid, baseY - crest, x1, baseY + 4);
    }

    path
      ..lineTo(w + 40, h)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  Path _buildGentleWavePath(double w, double h, double splitY, double t) {
    final double leftY;
    final double c1Y;
    final double midY;
    final double c2Y;
    final double rightY;

    if (t <= 1.0) {
      leftY = lerpDouble(splitY + 8, splitY - 8, t)!;
      c1Y = lerpDouble(splitY + 30, splitY - 14, t)!;
      midY = lerpDouble(splitY + 10, splitY + 18, t)!;
      c2Y = lerpDouble(splitY - 14, splitY + 24, t)!;
      rightY = lerpDouble(splitY - 10, splitY - 6, t)!;
    } else {
      final u = t - 1.0;
      leftY = lerpDouble(splitY - 8, splitY - 10, u)!;
      c1Y = lerpDouble(splitY - 14, splitY + 14, u)!;
      midY = lerpDouble(splitY + 18, splitY + 12, u)!;
      c2Y = lerpDouble(splitY + 24, splitY - 16, u)!;
      rightY = lerpDouble(splitY - 6, splitY - 2, u)!;
    }

    return Path()
      ..moveTo(0, leftY)
      ..quadraticBezierTo(w * 0.25, c1Y, w * 0.5, midY)
      ..quadraticBezierTo(w * 0.76, c2Y, w, rightY)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
  }

  void _drawDotGrid(
    Canvas canvas, {
    required Offset origin,
    required int rows,
    required int cols,
    required double spacing,
    required Color color,
  }) {
    final paint = Paint()..color = color;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        canvas.drawCircle(
          Offset(origin.dx + c * spacing, origin.dy + r * spacing),
          1.5,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _OnboardingWavePainter oldDelegate) =>
      oldDelegate.pageOffset != pageOffset;
}
