import 'dart:math';

import 'package:flutter/material.dart';

class GlowingCircularProgressBar extends StatefulWidget {
  const GlowingCircularProgressBar({super.key});

  @override
  State<GlowingCircularProgressBar> createState() =>
      _GlowingCircularProgressBarState();
}

class _GlowingCircularProgressBarState extends State<GlowingCircularProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    // Tween and Curve for smooth glowing animation
    _progressAnimation = Tween<double>(begin: 0, end: 1) // 75% progress
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: CircularGlowPainter(progress: _progressAnimation.value),
            size: Size(250, 250),
          );
        },
      ),
    );
  }
}

class CircularGlowPainter extends CustomPainter {
  final double progress;
  final bool useGradient;

  CircularGlowPainter({this.useGradient = true, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 20;

    // Background Circle
    final bgPaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18;

    canvas.drawCircle(center, radius, bgPaint);

    // Foreground Glow Progress
    final progressPaint = Paint();
    if (useGradient) {
      progressPaint.shader = SweepGradient(
        startAngle: 0,
        endAngle: pi * 2,
        colors: [
          Colors.deepPurpleAccent,
          Colors.green,
          Colors.deepPurpleAccent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    } else {
      progressPaint.color = Colors.deepPurpleAccent;
    }
    progressPaint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 19
      ..strokeCap = StrokeCap.round
      ..colorFilter = ColorFilter.mode(Colors.white, BlendMode.softLight)
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 3);

    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        sweepAngle, false, progressPaint);

    // Center Text
    TextPainter tp = TextPainter(
      text: TextSpan(
        text: "${(progress * 100).toInt()}%",
        style: TextStyle(
            color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CircularGlowPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
