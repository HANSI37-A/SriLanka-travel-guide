import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool darkBackground;

  const AppLogo({
    super.key,
    this.size = 70,
    this.showText = true,
    this.darkBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Logo Icon ──────────────────────────
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size * 0.26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: CustomPaint(
            size: Size(size, size),
            painter: _TeardropLogoPainter(),
          ),
        ),

        if (showText) ...[
          const SizedBox(height: 14),
          // ── App Name ───────────────────────────
          Text(
            'CeylonTrail',
            style: TextStyle(
              color: darkBackground ? Colors.white : const Color(0xFF1B4332),
              fontSize: size * 0.37,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          // ── Tagline ────────────────────────────
          Text(
            'EXPLORE SRI LANKA',
            style: TextStyle(
              color: darkBackground
                  ? Colors.white.withValues(alpha: 0.6)
                  : const Color(0xFF1B4332).withValues(alpha: 0.5),
              fontSize: size * 0.12,
              letterSpacing: 3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// ── Custom Painter for Teardrop Logo ───────────────────

class _TeardropLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.38;

    // Outer circle (border)
    final outerPaint = Paint()
      ..color = const Color(0xFF1B4332)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(Offset(cx, cy), r, outerPaint);

    // Teardrop / leaf shape (filled green)
    final teardropPaint = Paint()
      ..color = const Color(0xFF1B4332)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(cx - r * 0.78, cy);
    path.quadraticBezierTo(cx - r * 0.4, cy - r * 0.85, cx, cy - r * 0.65);
    path.quadraticBezierTo(cx + r * 0.4, cy - r * 0.85, cx + r * 0.78, cy);
    path.quadraticBezierTo(cx + r * 0.4, cy + r * 0.85, cx, cy + r * 0.65);
    path.quadraticBezierTo(cx - r * 0.4, cy + r * 0.85, cx - r * 0.78, cy);
    path.close();
    canvas.drawPath(path, teardropPaint);

    // Inner hole (white cutout)
    final holePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final innerPath = Path();
    final ir = r * 0.42;
    innerPath.moveTo(cx - ir * 0.78, cy);
    innerPath.quadraticBezierTo(
        cx - ir * 0.4, cy - ir * 0.85, cx, cy - ir * 0.65);
    innerPath.quadraticBezierTo(
        cx + ir * 0.4, cy - ir * 0.85, cx + ir * 0.78, cy);
    innerPath.quadraticBezierTo(
        cx + ir * 0.4, cy + ir * 0.85, cx, cy + ir * 0.65);
    innerPath.quadraticBezierTo(
        cx - ir * 0.4, cy + ir * 0.85, cx - ir * 0.78, cy);
    innerPath.close();
    canvas.drawPath(innerPath, holePaint);

    // Gold center dot
    final dotPaint = Paint()
      ..color = const Color(0xFFD4A843)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), r * 0.13, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}