import 'dart:math';
import 'package:flutter/material.dart';

class NumberGuessPage extends StatefulWidget {
  const NumberGuessPage({super.key});

  @override
  State<NumberGuessPage> createState() => _NumberGuessPageState();
}

class _NumberGuessPageState extends State<NumberGuessPage> {
  final Random _random = Random();
  late int _targetNumber;
  final TextEditingController _guessController = TextEditingController();
  String _feedback = '';
  bool _gameOver = false;
  int _guessCount = 0; // Tahmin sayacı

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _targetNumber = _random.nextInt(100) + 1;
      _feedback = 'Guess a number between 1 and 100!';
      _guessController.clear();
      _gameOver = false;
      _guessCount = 0; // Sayaç sıfırlandı
    });
  }

  void _checkGuess() {
    if (_gameOver) return;

    final guessText = _guessController.text;
    final guess = int.tryParse(guessText);

    if (guess == null || guess < 1 || guess > 100) {
      setState(() {
        _feedback = 'Please enter a valid number between 1 and 100!';
      });
      return;
    }

    setState(() {
      _guessCount++; // Tahmin sayısını artır

      if (guess == _targetNumber) {
        _feedback =
            'Congratulations! You guessed it right: $_targetNumber in $_guessCount tries.';
        _gameOver = true;
      } else if (guess < _targetNumber) {
        _feedback = 'Higher!';
      } else {
        _feedback = 'Lower!';
      }
    });

    _guessController.clear();
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Guessing Game'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _feedback,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _guessController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Guess',
              ),
              onSubmitted: (_) => _checkGuess(),
              enabled: !_gameOver,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkGuess,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Guess', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNewGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Restart', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
