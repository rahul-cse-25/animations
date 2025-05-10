import 'package:flutter/material.dart';

class HeartbeatAnimation extends StatefulWidget {
  const HeartbeatAnimation({super.key});

  @override
  State<HeartbeatAnimation> createState() => _HeartbeatAnimationState();
}

class _HeartbeatAnimationState extends State<HeartbeatAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true); // pulsing repeat

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Icon(
        Icons.favorite,
        color: Colors.redAccent,
        size: 100,
      ),
    );
  }
}

class GlowingHeartBeat extends StatefulWidget {
  const GlowingHeartBeat({super.key});

  @override
  State<GlowingHeartBeat> createState() => _GlowingHeartBeatState();
}

class _GlowingHeartBeatState extends State<GlowingHeartBeat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: CustomPaint(
            size: Size(200, 200),
            painter: HeartPainter(),
          ),
        );
      },
    );
  }
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 2); // glow effect

    Path heartPath = Path();
    final double x = size.width / 2;
    final double y = size.height / 2;

    heartPath.moveTo(x, y + 10);

    heartPath.cubicTo(x + 80, y - 40, x + 30, y - 90, x, y - 60);
    heartPath.cubicTo(x - 30, y - 90, x - 80, y - 40, x, y + 10);

    canvas.drawPath(heartPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
