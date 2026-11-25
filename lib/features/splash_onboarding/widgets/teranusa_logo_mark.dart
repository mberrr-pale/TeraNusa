import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Emblem logo resmi TeraNusa (Variasi A): lencana squircle hijau hutan
/// dengan siluet lengkung terasering/pulau Nusantara putih berlapis dan
/// matahari terbit amber hangat di atasnya.
class TeraNusaLogoMark extends StatelessWidget {
  final double size;

  const TeraNusaLogoMark({super.key, this.size = 88});

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.28;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF236E2C), AppColors.primary, Color(0xFF0E4418)],
          stops: [0.0, 0.52, 1.0],
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.24),
            blurRadius: size * 0.28,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CustomPaint(
          size: Size.square(size),
          painter: const _TeraNusaSunrisePainter(),
        ),
      ),
    );
  }
}

class _TeraNusaSunrisePainter extends CustomPainter {
  const _TeraNusaSunrisePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Matahari terbit amber hangat dengan gradasi & cincin cahaya lembut
    final sunCenter = Offset(w * 0.5, h * 0.49);
    final sunRadius = w * 0.235;
    final sunRect = Rect.fromCircle(center: sunCenter, radius: sunRadius);

    final outerSunPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF6B94A), Color(0xFFE79526)],
      ).createShader(sunRect);
    canvas.drawCircle(sunCenter, sunRadius, outerSunPaint);

    // Inti matahari sedikit lebih hangat di tengah (kedalaman halus ala Variasi A)
    final innerSunPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFEB9B2B), Color(0xFFD98319)],
      ).createShader(
        Rect.fromCircle(center: Offset(w * 0.5, h * 0.52), radius: w * 0.165),
      );
    canvas.drawCircle(Offset(w * 0.5, h * 0.52), w * 0.165, innerSunPaint);

    // 2. Siluet lengkung terasering / kepulauan Nusantara putih berlapis
    //    dipotong rapi dalam bentuk mangkuk setengah lingkaran di bagian bawah.
    final bowlClip = Path()
      ..moveTo(w * 0.14, h * 0.49)
      ..lineTo(w * 0.86, h * 0.49)
      ..cubicTo(w * 0.84, h * 0.74, w * 0.68, h * 0.85, w * 0.5, h * 0.85)
      ..cubicTo(w * 0.32, h * 0.85, w * 0.16, h * 0.74, w * 0.14, h * 0.49)
      ..close();

    canvas.save();
    canvas.clipPath(bowlClip);

    final whitePaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    // Bukit kanan belakang (muncul di sebelah kanan bawah matahari)
    final rightHill = Path()
      ..moveTo(w * 0.45, h * 0.62)
      ..quadraticBezierTo(w * 0.64, h * 0.47, w * 0.88, h * 0.51)
      ..lineTo(w * 0.88, h * 0.74)
      ..quadraticBezierTo(w * 0.68, h * 0.71, w * 0.52, h * 0.62)
      ..close();
    canvas.drawPath(rightHill, whitePaint);

    // Gelombang terasering utama kiri-ke-kanan
    final mainTerrace = Path()
      ..moveTo(w * 0.12, h * 0.51)
      ..quadraticBezierTo(w * 0.36, h * 0.48, w * 0.55, h * 0.62)
      ..quadraticBezierTo(w * 0.7, h * 0.72, w * 0.86, h * 0.7)
      ..lineTo(w * 0.86, h * 0.82)
      ..quadraticBezierTo(w * 0.66, h * 0.81, w * 0.49, h * 0.7)
      ..quadraticBezierTo(w * 0.32, h * 0.6, w * 0.14, h * 0.64)
      ..close();
    canvas.drawPath(mainTerrace, whitePaint);

    // Lapisan terasering dasar di paling bawah
    final bottomTerrace = Path()
      ..moveTo(w * 0.18, h * 0.68)
      ..quadraticBezierTo(w * 0.34, h * 0.65, w * 0.49, h * 0.74)
      ..quadraticBezierTo(w * 0.62, h * 0.82, w * 0.76, h * 0.83)
      ..lineTo(w * 0.76, h * 0.9)
      ..lineTo(w * 0.18, h * 0.9)
      ..close();
    canvas.drawPath(bottomTerrace, whitePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TeraNusaSunrisePainter oldDelegate) => false;
}
