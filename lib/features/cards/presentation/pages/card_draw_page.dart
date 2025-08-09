import 'dart:math';
import 'package:flutter/material.dart';

class CardDrawPage extends StatefulWidget {
  const CardDrawPage({super.key});

  @override
  State<CardDrawPage> createState() => _CardDrawPageState();
}

class _CardDrawPageState extends State<CardDrawPage>
    with SingleTickerProviderStateMixin {
  late List<String> _deck;
  String? _drawnCard;

  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  final Map<String, String> suitsMap = {
    '♣': 'clubs',
    '♦': 'diamonds',
    '♥': 'hearts',
    '♠': 'spades',
  };

  final Map<String, String> ranksMap = {
    'A': 'ace',
    '2': '2',
    '3': '3',
    '4': '4',
    '5': '5',
    '6': '6',
    '7': '7',
    '8': '8',
    '9': '9',
    '10': '10',
    'J': 'jack',
    'Q': 'queen',
    'K': 'king',
  };

  @override
  void initState() {
    super.initState();
    _generateDeck();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  void _generateDeck() {
    const suits = ['♣', '♦', '♥', '♠'];
    const ranks = [
      'A',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'J',
      'Q',
      'K',
    ];

    _deck = [
      for (var suit in suits)
        for (var rank in ranks) '$rank$suit',
    ];

    _deck.shuffle();
    _drawnCard = null;
  }

  void _drawCard() {
    if (_deck.isEmpty) return;

    _controller.reset();
    _controller.forward().then((_) {
      setState(() {
        _drawnCard = _deck.removeLast();
      });
    });
  }

  String _getAssetPath(String card) {
    final rankChar = card.substring(0, card.length - 1);
    final suitChar = card.substring(card.length - 1);

    final suitName = suitsMap[suitChar] ?? 'clubs';
    final rankName = ranksMap[rankChar] ?? 'ace';

    return 'assets/cards/${rankName}_of_${suitName}.png';
  }

  Widget _buildCardFace() {
    if (_drawnCard == null) {
      return Container(
        width: 180,
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.green.shade700,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text('🃏', style: TextStyle(fontSize: 128)),
      );
    } else {
      final path = _getAssetPath(_drawnCard!);
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 180,
          height: 260,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 4),
              ),
            ],
            color: Colors.white,
          ),
          child: Image.asset(
            path,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  'No image found',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = _deck.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Draw Card"),
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
                final isFront = _flipAnimation.value < pi / 2;

                return Transform(
                  transform: Matrix4.rotationY(
                    isFront ? _flipAnimation.value : _flipAnimation.value - pi,
                  ),
                  alignment: Alignment.center,
                  child: isFront ? _buildCardBack() : _buildCardFace(),
                );
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 160,
              height: 50,
              child: ElevatedButton(
                onPressed: isEmpty ? null : _drawCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: Colors.deepPurpleAccent,
                ),
                child: Text(
                  isEmpty ? "All Cards Drawn" : "Draw Card",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (isEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    _generateDeck();
                  });
                },
                child: const Text(
                  "Reset Deck",
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: 180,
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.green.shade700,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4)),
        ],
      ),
      alignment: Alignment.center,
      child: const Text('🃏', style: TextStyle(fontSize: 128)),
    );
  }
}
