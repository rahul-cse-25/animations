import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class FollowingStar extends StatefulWidget {
  const FollowingStar({super.key});

  @override
  State<FollowingStar> createState() => _FollowingStarState();
}

class _FollowingStarState extends State<FollowingStar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(
            painter: StarPainter(),
          ),
        ),
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 50.0; // Adjust the radius as needed

    canvas.drawCircle(center, radius, paint);

    final starPoints = List.generate(3, (index) {
      final angle =
          (index * 2 * 3.14159 / 3) - 0.5; // Adjust the angle as needed
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      return Offset(x, y);
    });

    canvas.drawPoints(PointMode.polygon, starPoints, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
