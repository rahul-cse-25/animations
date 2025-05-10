import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomProgressBar extends LeafRenderObjectWidget {
  final double progress;
  final VoidCallback onReset;

  const CustomProgressBar({
    required this.progress,
    required this.onReset,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomProgressBar(progress, onReset);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomProgressBar renderObject) {
    renderObject..progress = progress..onReset = onReset;
  }
}

class RenderCustomProgressBar extends RenderBox {
  double _progress;
  VoidCallback _onReset;

  RenderCustomProgressBar(this._progress, this._onReset);

  set progress(double newProgress) {
    if (_progress == newProgress) return;
    _progress = newProgress;
    markNeedsPaint();
  }

  set onReset(VoidCallback callback) {
    _onReset = callback;
  }

  @override
  void performLayout() {
    size = constraints.constrain(Size(constraints.maxWidth, 20));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final Paint background = Paint()..color = Colors.grey.shade300;
    final Paint foreground = Paint()..color = Colors.green;

    // Background bar
    canvas.drawRect(offset & size, background);

    // Foreground progress
    final double progressWidth = size.width * _progress.clamp(0.0, 1.0);
    final Rect progressRect =
        Rect.fromLTWH(offset.dx, offset.dy, progressWidth, size.height);
    canvas.drawRect(progressRect, foreground);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent) {
      _onReset(); // reset progress to 0
    }
  }
}


class ProgressExample extends StatefulWidget {
  const ProgressExample({super.key});

  @override
  State<ProgressExample> createState() => _ProgressExampleState();
}

class _ProgressExampleState extends State<ProgressExample> {
  double _progress = 0.4;

  void _resetProgress() {
    setState(() => _progress = 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Progress Bar')),
      body: Column(
        children: [
          const SizedBox(height: 40),
          CustomProgressBar(
            progress: _progress,
            onReset: _resetProgress,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _progress += 0.1;
              });
            },
            child: const Text("Increase"),
          ),
        ],
      ),
    );
  }
}
