import 'dart:math';
import 'package:flutter/material.dart';

class DynamicWheelPage extends StatefulWidget {
  const DynamicWheelPage({super.key});

  @override
  State<DynamicWheelPage> createState() => _DynamicWheelPageState();
}

class _DynamicWheelPageState extends State<DynamicWheelPage>
    with SingleTickerProviderStateMixin {
  List<String> segments = ["Segment 1", "Segment 2"];
  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController _textController = TextEditingController();
  final Random _random = Random();
  double _currentAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _addSegment() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        segments.add(text);
        _textController.clear();
      });
    }
    FocusScope.of(context).unfocus();
  }

  void _deleteSegment(int index) {
    setState(() {
      segments.removeAt(index);
    });
  }

  void _editSegment(int index) {
    final editController = TextEditingController(text: segments[index]);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Segment"),
        content: TextField(
          controller: editController,
          autofocus: true,
          maxLength: 20,
          decoration: const InputDecoration(labelText: "Segment Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newText = editController.text.trim();
              if (newText.isNotEmpty) {
                setState(() {
                  segments[index] = newText;
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _spinWheel() {
    if (_controller.isAnimating || segments.isEmpty) return;

    final spins = _random.nextInt(5) + 5;
    final targetAngle =
        _currentAngle + spins * 2 * pi + _random.nextDouble() * 2 * pi;

    _animation = Tween<double>(
      begin: _currentAngle,
      end: targetAngle,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller
      ..reset()
      ..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentAngle = _animation.value % (2 * pi);
          // _showWinner(); // burayı kaldırdık, popup çıkmayacak artık
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wheel"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => Transform.rotate(
                  angle: _animation.value,
                  child: CustomPaint(painter: WheelPainter(segments)),
                ),
              ),
            ),
            const Icon(Icons.arrow_upward, size: 50, color: Colors.red),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    maxLength: 20,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: "Add new segment",
                      counterText: "",
                    ),
                    onSubmitted: (_) => _addSegment(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addSegment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Add"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Contents",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: segments.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade200,
                    child: Text((index + 1).toString()),
                  ),
                  title: Text(segments[index], overflow: TextOverflow.ellipsis),
                  onTap: () => _editSegment(index),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteSegment(index),
                    tooltip: "Delete",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _spinWheel,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.sync),
        tooltip: "Spin Wheel",
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<String> segments;
  WheelPainter(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    if (segments.isEmpty) {
      canvas.drawCircle(center, radius, Paint()..color = Colors.grey.shade300);
      return;
    }

    final segmentAngle = 2 * pi / segments.length;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < segments.length; i++) {
      paint.color = i.isEven
          ? Colors.deepPurple.shade700
          : Colors.deepPurple.shade700;
      final startAngle = segmentAngle * i - pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        paint,
      );

      // Segment border
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.white
          ..strokeWidth = 2,
      );

      // Text
      final textPainter = TextPainter(
        text: TextSpan(
          text: segments[i],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: radius * 0.6);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(startAngle + segmentAngle / 2);
      textPainter.paint(canvas, Offset(radius * 0.25, -textPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
