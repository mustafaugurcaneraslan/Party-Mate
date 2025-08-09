import 'dart:math';
import 'package:flutter/material.dart';

class CoinFlipPage extends StatefulWidget {
  const CoinFlipPage({super.key});

  @override
  State<CoinFlipPage> createState() => _CoinFlipPageState();
}

class _CoinFlipPageState extends State<CoinFlipPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  final Random _random = Random();

  bool _isHeads = true;
  bool _showCoin = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showCoin = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCoin() {
    if (_controller.isAnimating) return;

    setState(() {
      _showCoin = false;
    });

    _isHeads = _random.nextBool();
    _controller.reset();
    _controller.forward();
  }

  Widget _buildCoinFace() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(75),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade300.withOpacity(0.7),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        _isHeads ? 'Heads' : 'Tails',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Flip'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final isFront = _flipAnimation.value <= (pi / 2);
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(_flipAnimation.value),
                  child: isFront
                      ? Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.shade700,
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '🪙',
                            style: TextStyle(fontSize: 64),
                          ),
                        )
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: _showCoin
                              ? _buildCoinFace()
                              : const SizedBox(width: 150, height: 150),
                        ),
                );
              },
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: 180,
              height: 60,
              child: ElevatedButton(
                onPressed: _flipCoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: Colors.deepPurpleAccent,
                ),
                child: const Text('Flip Coin', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
