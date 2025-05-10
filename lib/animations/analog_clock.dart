import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class AnalogClock extends StatefulWidget {
  const AnalogClock({super.key});

  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();

    // Har second me update
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockPainter(_dateTime),
      size: Size(300, 300),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter(this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);

    final fillBrush = Paint()..color = Colors.black;
    final outlineBrush = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final centerDot = Paint()..color = Colors.white;

    final secHand = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final minHand = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final hourHand = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final tickPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius - 10, fillBrush);

    for (int i = 0; i < 60; i++) {
      double tickLength = (i % 5 == 0) ? 10 : 5;
      double angle = (pi / 30) * i;
      Offset start = Offset(
        center.dx + (radius - 15) * cos(angle),
        center.dy + (radius - 15) * sin(angle),
      );
      Offset end = Offset(
        center.dx + (radius - 15 - tickLength) * cos(angle),
        center.dy + (radius - 15 - tickLength) * sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    // Background

    canvas.drawCircle(center, radius - 10, outlineBrush);

    // Hour hand
    double hourDeg = (dateTime.hour % 12 + dateTime.minute / 60) * 30;
    double hourRadian = radians(hourDeg);
    final hourHandOffset = Offset(
      centerX + 50 * cos(hourRadian - pi / 2),
      centerY + 50 * sin(hourRadian - pi / 2),
    );
    canvas.drawLine(center, hourHandOffset, hourHand);

    // Minute hand
    double minRadian = radians(dateTime.minute * 6);
    final minHandOffset = Offset(
      centerX + 70 * cos(minRadian - pi / 2),
      centerY + 70 * sin(minRadian - pi / 2),
    );
    canvas.drawLine(center, minHandOffset, minHand);

    // Second hand
    double secRadian = radians(dateTime.second * 6);
    final secHandOffset = Offset(
      centerX + 90 * cos(secRadian - pi / 2),
      centerY + 90 * sin(secRadian - pi / 2),
    );
    canvas.drawLine(center, secHandOffset, secHand);

    // Center dot
    canvas.drawCircle(center, 6, centerDot);
  }

  double radians(double degrees) => degrees * pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
