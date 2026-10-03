import 'dart:math' as math;
import 'package:flutter/material.dart';

class EkubLogo extends StatelessWidget {
  final double size;

  const EkubLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFEFF4F1),
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: _EkubLogoPainter(),
      ),
    );
  }
}

class _EkubLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Draw 3 outer segmented arc strokes
    final strokeWidth = size.width * 0.08;
    final arcRadius = radius * 0.76;
    final arcPaint = Paint()
      ..color = const Color(0xFF1B4E3B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (2 * math.pi / 3) - 0.45;

    // Arc 1 (Top right)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: arcRadius),
      -math.pi / 6,
      sweepAngle,
      false,
      arcPaint,
    );

    // Arc 2 (Bottom right / bottom)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: arcRadius),
      math.pi / 2,
      sweepAngle,
      false,
      arcPaint,
    );

    // Arc 3 (Top left)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: arcRadius),
      7 * math.pi / 6,
      sweepAngle,
      false,
      arcPaint,
    );

    // 2. Draw 3 overlapping inner circles
    final innerCircleRadius = radius * 0.28;
    final offsetDistance = radius * 0.16;

    // Circle 1: Top-Left (Dark Green)
    final centerTL = center + Offset(-offsetDistance * 0.9, -offsetDistance * 0.8);
    final paintTL = Paint()
      ..color = const Color(0xFF275C4A).withOpacity(0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(centerTL, innerCircleRadius, paintTL);

    // Circle 2: Top-Right (Terracotta Orange)
    final centerTR = center + Offset(offsetDistance * 0.9, -offsetDistance * 0.8);
    final paintTR = Paint()
      ..color = const Color(0xFFC8663D).withOpacity(0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(centerTR, innerCircleRadius, paintTR);

    // Circle 3: Bottom-Center (Dark Green)
    final centerB = center + Offset(0, offsetDistance * 0.9);
    final paintB = Paint()
      ..color = const Color(0xFF1E4E3B).withOpacity(0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(centerB, innerCircleRadius, paintB);

    // 3. Draw small green triangle arrow pointing right inside the terracotta circle
    final triCenter = centerTR + Offset(innerCircleRadius * 0.35, 0);
    final triSize = innerCircleRadius * 0.55;

    final path = Path();
    path.moveTo(triCenter.dx + triSize * 0.5, triCenter.dy);
    path.lineTo(triCenter.dx - triSize * 0.4, triCenter.dy - triSize * 0.45);
    path.lineTo(triCenter.dx - triSize * 0.4, triCenter.dy + triSize * 0.45);
    path.close();

    final triPaint = Paint()
      ..color = const Color(0xFF1B4E3B)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, triPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
