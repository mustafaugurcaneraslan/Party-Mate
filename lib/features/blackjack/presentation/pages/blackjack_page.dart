import 'dart:math';
import 'package:flutter/material.dart';

class BlackjackPage extends StatefulWidget {
  const BlackjackPage({super.key});

  @override
  State<BlackjackPage> createState() => _BlackjackPageState();
}

class _BlackjackPageState extends State<BlackjackPage> {
  final Random _random = Random();

  List<String> playerCards = [];
  List<String> dealerCards = [];

  int playerTotal = 0;
  int dealerTotal = 0;
  String gameStatus = "";

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    setState(() {
      playerCards = [_drawCard(), _drawCard()];
      dealerCards = [_drawCard(), _drawCard()];
      gameStatus = "";
      playerTotal = _calculateTotal(playerCards);
      dealerTotal = _calculateTotal(dealerCards);
    });
  }

  String _drawCard() {
    final cards = [
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
    return cards[_random.nextInt(cards.length)];
  }

  int _calculateTotal(List<String> cards) {
    int total = 0;
    int aceCount = 0;

    for (String card in cards) {
      if (card == 'A') {
        total += 11;
        aceCount++;
      } else if (['K', 'Q', 'J'].contains(card)) {
        total += 10;
      } else {
        total += int.parse(card);
      }
    }

    while (total > 21 && aceCount > 0) {
      total -= 10;
      aceCount--;
    }

    return total;
  }

  void _playerHit() {
    setState(() {
      playerCards.add(_drawCard());
      playerTotal = _calculateTotal(playerCards);

      if (playerTotal > 21) {
        gameStatus = "BUST! You Lose.";
      }
    });
  }

  void _playerStand() {
    setState(() {
      while (dealerTotal < 17) {
        dealerCards.add(_drawCard());
        dealerTotal = _calculateTotal(dealerCards);
      }

      if (dealerTotal > 21) {
        gameStatus = "Dealer BUST! You Win!";
      } else if (dealerTotal > playerTotal) {
        gameStatus = "You Lose.";
      } else if (dealerTotal < playerTotal) {
        gameStatus = "You Win!";
      } else {
        gameStatus = "Draw!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blackjack"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.deepPurple.shade800,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          // <-- Bu Center widget'ını ekledik
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Dealer",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 8),
              Wrap(
                children: dealerCards.map((card) => _buildCard(card)).toList(),
              ),
              Text(
                "Total: $dealerTotal",
                style: const TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 30),

              const Text(
                "You",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 8),
              Wrap(
                children: playerCards.map((card) => _buildCard(card)).toList(),
              ),
              Text(
                "Total: $playerTotal",
                style: const TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 30),
              Text(
                gameStatus,
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              if (gameStatus.isEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _playerHit,
                      child: const Text("Hit"),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _playerStand,
                      child: const Text("Stand"),
                    ),
                  ],
                ),

              if (gameStatus.isNotEmpty)
                ElevatedButton(
                  onPressed: _startGame,
                  child: const Text("Play Again"),
                ),
            ],
          ),
        ), // <-- Buraya da Center widget'ının sonunu ekledik
      ),
    );
  }

  Widget _buildCard(String card) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      width: 50,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          card,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
