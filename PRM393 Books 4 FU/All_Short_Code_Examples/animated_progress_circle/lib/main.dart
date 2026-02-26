import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  void _performAnimation() {
    if (_controller.status != AnimationStatus.forward) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 10), vsync: this)
          ..addListener(() {
            setState(() {}); // Force rebuild
          });
  }

  @override
  void dispose() {
    _controller.dispose(); // avoid memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("_controller: ${_controller.value.toStringAsFixed(2)}"),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CustomPaint(
            foregroundPainter: ProgressCirclePainter(
              lineColor: Colors.amber,
              completeColor: Colors.blueAccent,
              completePercent: _controller.value * 100,
              width: 18.0,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _performAnimation,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class ProgressCirclePainter extends CustomPainter {
  final Color lineColor;
  final Color completeColor;
  final double completePercent;
  final double width;

  ProgressCirclePainter({
    required this.lineColor,
    required this.completeColor,
    required this.completePercent,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Paint complete = Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    // Base circle
    canvas.drawCircle(center, radius, line);

    // Progress arc
    final arcAngle = 2 * pi * (completePercent / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      arcAngle,
      false,
      complete,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
