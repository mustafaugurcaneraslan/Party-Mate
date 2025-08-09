import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Party Mate'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildButton(
                context,
                'Roll Dice',
                '/dice',
                icon: Icons.casino_outlined,
                color: Colors.purple.shade700,
              ),
              _buildButton(
                context,
                'Spin Wheel',
                '/wheel',
                icon: Icons.sync_alt,
                color: Colors.purple.shade700,
              ),
              _buildButton(
                context,
                'Spin Bottle',
                '/bottle',
                icon: Icons.local_bar,
                color: Colors.purple.shade700,
              ),
              _buildButton(
                context,
                'Draw Card',
                '/cards',
                icon: Icons.style,
                color: Colors.purple.shade700,
              ),
              _buildButton(
                context,
                'Blackjack',
                '/blackjack',
                icon: Icons.card_giftcard,
                color: Colors.purple.shade700,
              ),
              _buildButton(
                context,
                'Coin Flip',
                '/coinflip',
                icon: Icons.monetization_on,
                color: Colors.purple.shade700,
              ),
              _buildButton(
                context,
                'Number Guess',
                '/numberguess',
                icon: Icons.help_outline,
                color: Colors.purple.shade700,
              ),
              _buildButton(
                context,
                'Roulette',
                '/roulette',
                icon: Icons.casino,
                color: Colors.purple.shade700,
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    String route, {
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: ElevatedButton.icon(
          icon: Icon(icon, size: 28),
          label: Text(text, style: const TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            elevation: 5,
            shadowColor: Colors.black38,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () => Navigator.pushNamed(context, route),
        ),
      ),
    );
  }
}
