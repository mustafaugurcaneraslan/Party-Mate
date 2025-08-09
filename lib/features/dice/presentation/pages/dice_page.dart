import 'dart:math';
import 'package:flutter/material.dart';

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> with TickerProviderStateMixin {
  int _diceCount = 1;
  final List<int> _diceNumbers = [1];
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    for (var c in _controllers) {
      c.dispose();
    }
    _controllers.clear();
    _animations.clear();

    for (int i = 0; i < _diceCount; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 700),
      );

      final animation = Tween<double>(
        begin: 0,
        end: 2 * pi,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _diceNumbers[i] = _random.nextInt(6) + 1;
          });
          controller.reset();
        }
      });

      _controllers.add(controller);
      _animations.add(animation);
    }

    while (_diceNumbers.length < _diceCount) {
      _diceNumbers.add(1);
    }
    while (_diceNumbers.length > _diceCount) {
      _diceNumbers.removeLast();
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _rollDice() {
    for (var controller in _controllers) {
      if (!controller.isAnimating) {
        controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalScore = _diceNumbers.fold(0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roll Dice'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Dice Count: ',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                DropdownButton<int>(
                  dropdownColor: Colors.deepPurple.shade700,
                  value: _diceCount,
                  items: List.generate(
                    6,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _diceCount = value;
                        _initAnimations();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: List.generate(_diceCount, (index) {
                return AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animations[index].value,
                      child: child,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/dice${_diceNumbers[index]}.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            Text(
              'Total: $totalScore',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              height: 70,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.casino_outlined, size: 28),
                label: const Text('Roll Dice', style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  elevation: 5,
                  shadowColor: Colors.black38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _rollDice,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
