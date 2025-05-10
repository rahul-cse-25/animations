import 'package:animations/animations/analog_clock.dart';
import 'package:animations/animations/heart.dart';
import 'package:flutter/material.dart';

import 'animations/glow_progess.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Animations"),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const AnalogClock(),
              GlowingCircularProgressBar(),
              HeartbeatAnimation(),
              GlowingHeartBeat(),
            ],
          ),
        ),
      ),
    );
  }
}
