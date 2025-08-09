import 'dart:math';
import 'package:flutter/material.dart';

class BottleSpinPage extends StatefulWidget {
  const BottleSpinPage({super.key});

  @override
  State<BottleSpinPage> createState() => _BottleSpinPageState();
}

class _BottleSpinPageState extends State<BottleSpinPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentAngle = 0.0;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation =
        Tween<double>(begin: 0, end: 0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.decelerate),
        )..addListener(() {
          setState(() {
            _currentAngle = _animation.value;
          });
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spinBottle() {
    if (!_controller.isAnimating) {
      final spins = _random.nextInt(6) + 5; // 5-10 tur arası
      final double endAngle =
          _currentAngle + spins * 2 * pi + _random.nextDouble() * 2 * pi;

      _animation =
          Tween<double>(begin: _currentAngle, end: endAngle).animate(
            CurvedAnimation(parent: _controller, curve: Curves.decelerate),
          )..addListener(() {
            setState(() {
              _currentAngle = _animation.value;
            });
          });

      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    double bottleSize = 400;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Spin Bottle"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: _currentAngle,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/bottle.png', // Projende bu asset olmalı
                  width: bottleSize,
                  height: bottleSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 180,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: Colors.deepPurpleAccent,
                ),
                onPressed: _spinBottle,
                child: const Text(
                  "Spin Bottle",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
