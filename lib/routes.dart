import 'package:flutter/material.dart';
import 'package:partymate/features/blackjack/presentation/pages/blackjack_page.dart';
import 'package:partymate/features/cards/presentation/pages/card_draw_page.dart';
import 'package:partymate/features/coinflip/presentation/pages/coinflip.dart';
import 'package:partymate/features/numberguess/presentation/pages/number_guess_page.dart';
import 'package:partymate/features/roulette/presentation/pages/roulette_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/dice/presentation/pages/dice_page.dart';
import 'features/wheel/presentation/pages/wheel_page.dart';
import 'features/bottle/presentation/pages/bottle_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/dice':
        return MaterialPageRoute(builder: (_) => const DicePage());
      case '/wheel':
        return MaterialPageRoute(builder: (_) => const DynamicWheelPage());
      case '/bottle':
        return MaterialPageRoute(builder: (_) => const BottleSpinPage());
      case '/cards':
        return MaterialPageRoute(builder: (_) => const CardDrawPage());
      case '/blackjack':
        return MaterialPageRoute(builder: (_) => const BlackjackPage());
      case '/coinflip':
        return MaterialPageRoute(builder: (_) => const CoinFlipPage());
      case '/numberguess':
        return MaterialPageRoute(builder: (_) => const NumberGuessPage());
      case '/roulette':
        return MaterialPageRoute(builder: (_) => const RoulettePage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Sayfa bulunamadı')),
          ),
        );
    }
  }
}
