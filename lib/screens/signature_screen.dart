
import 'package:flutter/material.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  Color _selectedColor = Colors.black;

  final List<List<Offset>> _strokes = [];
  final List<Color> _strokeColors = [];

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _strokeColors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 5: Signature Canvas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Kanvas Tanda Tangan Digital',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Gunakan jari untuk membuat coretan pada area putih.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _strokes.add([details.localPosition]);
                      _strokeColors.add(_selectedColor);
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      _strokes.last.add(details.localPosition);
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {});
                  },
                  child: CustomPaint(
                    painter: SignaturePainter(
                      strokes: _strokes,
                      colors: _strokeColors,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Pilih Warna Pena',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _colorButton(Colors.black),
                _colorButton(Colors.red),
                _colorButton(Colors.blue),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _clearCanvas,
                icon: const Icon(Icons.delete),
                label: const Text('Hapus Kanvas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color
                ? Colors.orange
                : Colors.grey,
            width: _selectedColor == color ? 4 : 1,
          ),
        ),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Color> colors;

  SignaturePainter({
    required this.strokes,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < strokes.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final path = Path();

      if (strokes[i].isNotEmpty) {
        path.moveTo(
          strokes[i][0].dx,
          strokes[i][0].dy,
        );

        for (int j = 1; j < strokes[i].length; j++) {
          path.lineTo(
            strokes[i][j].dx,
            strokes[i][j].dy,
          );
        }

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SignaturePainter oldDelegate) {
    return true;
  }
}
