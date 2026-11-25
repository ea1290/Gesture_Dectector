
import 'package:flutter/material.dart';

class ScaleSwipeScreen extends StatefulWidget {
  const ScaleSwipeScreen({super.key});

  @override
  State<ScaleSwipeScreen> createState() => _ScaleSwipeScreenState();
}

class _ScaleSwipeScreenState extends State<ScaleSwipeScreen> {
  int _currentIndex = 0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  double _currentRotation = 0.0;
  double _baseRotation = 0.0;

  final List<Map<String, dynamic>> _galleryItems = const [
    {
      'title': 'Eksplorasi Pegunungan',
      'tag': 'KARTU 1 / 3',
      'desc': 'Gunakan dua jari untuk memperbesar atau memutar kartu ini.',
      'icon': Icons.terrain,
      'color': Color(0xFF0F766E),
    },
    {
      'title': 'Arsitektur Modern',
      'tag': 'KARTU 2 / 3',
      'desc': 'Usap ke kiri atau kanan pada area bawah untuk berpindah kartu.',
      'icon': Icons.location_city,
      'color': Color(0xFF1D4ED8),
    },
    {
      'title': 'Observasi Antariksa',
      'tag': 'KARTU 3 / 3',
      'desc': 'Tekan tombol Reset untuk mengembalikan skala ke 1.0x.',
      'icon': Icons.auto_awesome,
      'color': Color(0xFF6D28D9),
    },
  ];

  void _resetTransform() {
    setState(() {
      _currentScale = 1.0;
      _baseScale = 1.0;
      _currentRotation = 0.0;
      _baseRotation = 0.0;
    });
  }

  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _galleryItems.length;
      _resetTransform();
    });
  }

  void _prevCard() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _galleryItems.length) %
              _galleryItems.length;
      _resetTransform();
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = _galleryItems[_currentIndex];
    final Color cardColor = item['color'] as Color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 4: Pinch & Swipe'),
        actions: [
          IconButton(
            tooltip: 'Kembali ke Beranda',
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Skala: ${_currentScale.toStringAsFixed(2)}x',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rotasi: ${(_currentRotation * 57.2958).toStringAsFixed(0)}°',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: _resetTransform,
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: GestureDetector(
                  onScaleStart: (details) {
                    _baseScale = _currentScale;
                    _baseRotation = _currentRotation;
                  },
                  onScaleUpdate: (details) {
                    setState(() {
                      _currentScale =
                          (_baseScale * details.scale).clamp(0.6, 2.2);
                      _currentRotation =
                          _baseRotation + details.rotation;
                    });
                  },
                  child: Transform.rotate(
                    angle: _currentRotation,
                    child: Transform.scale(
                      scale: _currentScale,
                      child: Container(
                        width: 270,
                        height: 310,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: cardColor.withAlpha(95),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item['tag'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Icon(
                              item['icon'] as IconData,
                              size: 76,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              item['title'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['desc'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity == null) return;

                if (details.primaryVelocity! < -200) {
                  _nextCard();
                } else if (details.primaryVelocity! > 200) {
                  _prevCard();
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFBFDBFE),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _galleryItems.length,
                        (idx) {
                          final isActive = idx == _currentIndex;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            width: isActive ? 22 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF1B365D)
                                  : const Color(0xFF94A3B8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '← Usap Kiri atau Kanan untuk Ganti Kartu →',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B365D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
