import 'dart:math';
import 'package:flutter/material.dart';

class RoulettePage extends StatefulWidget {
  const RoulettePage({super.key});

  @override
  State<RoulettePage> createState() => _RoulettePageState();
}

class _RoulettePageState extends State<RoulettePage>
    with SingleTickerProviderStateMixin {
  late List<String> segments;

  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();

  double _currentAngle = 0.0;
  String _result = "";

  @override
  void initState() {
    super.initState();

    // 1-36 arası sayılar + 0'ı başa koyup listeyi karıştırıyoruz
    segments = List<String>.generate(36, (index) => (index + 1).toString());
    segments.insert(0, "0");
    segments.shuffle(_random);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentAngle = _animation.value % (2 * pi);
          _result = _calculateWinner();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_controller.isAnimating) return;

    final spins = _random.nextInt(8) + 8; // 8-15 tur arası döndür
    final targetAngle =
        _currentAngle + spins * 2 * pi + _random.nextDouble() * 2 * pi;

    _animation = Tween<double>(
      begin: _currentAngle,
      end: targetAngle,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller
      ..reset()
      ..forward();

    setState(() {
      _result = "";
    });
  }

  String _calculateWinner() {
    final segmentAngle = 2 * pi / segments.length;
    const pointerAngle = 3 * pi / 2; // Yukarıdaki ok ile hizalanıyor
    double normalizedAngle = pointerAngle - _currentAngle;
    if (normalizedAngle < 0) normalizedAngle += 2 * pi;

    final winnerIndex =
        (normalizedAngle / segmentAngle).floor() % segments.length;
    return segments[winnerIndex];
  }

  // Klasik rulette renkler: 0 = yeşil, diğerleri pozisyona göre dönüşümlü siyah-kırmızı
  Color _getSegmentColor(int index, String segment) {
    if (segment == "0") return Colors.green.shade700;

    // index çiftse siyah, tekse kırmızı
    return (index % 2 == 0) ? Colors.black : Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Roulette"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 320,
              height: 320,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: _animation.value,
                        child: CustomPaint(
                          size: const Size(320, 320),
                          painter: RoulettePainter(segments, _getSegmentColor),
                        ),
                      ),
                      // Pointer (kırmızı ok)
                      Positioned(
                        top: 135,
                        left: 5,
                        child: Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _result.isEmpty ? "Press Spin to play" : "Result: $_result",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _spinWheel,
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
              child: const Text("Spin", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

class RoulettePainter extends CustomPainter {
  final List<String> segments;
  final Color Function(int, String) getSegmentColor;

  RoulettePainter(this.segments, this.getSegmentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = 2 * pi / segments.length;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < segments.length; i++) {
      paint.color = getSegmentColor(i, segments[i]);

      final startAngle = segmentAngle * i - pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        paint,
      );

      // Segment çizgisi
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.white
          ..strokeWidth = 1,
      );

      // Yazı çizimi
      final textPainter = TextPainter(
        text: TextSpan(
          text: segments[i],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(maxWidth: radius * 0.5);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(startAngle + segmentAngle / 2);
      textPainter.paint(canvas, Offset(radius * 0.6, -textPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
