
import 'package:flutter/material.dart';
import 'scale_swipe_screen.dart';


class DragCanvasScreen extends StatefulWidget {
  const DragCanvasScreen({super.key});

  @override
  State<DragCanvasScreen> createState() => _DragCanvasScreenState();
}

class _DragCanvasScreenState extends State<DragCanvasScreen> {
  double _posX = 40;
  double _posY = 40;

  bool _isDragging = false;
  bool _isHit = false;

  int _score = 0;
  int _lives = 3;

  static const double _objectSize = 72;
  static const double _targetSize = 110;
  static const double _obstacleSize = 100;

  void _resetRocket() {
    setState(() {
      _posX = 40;
      _posY = 40;
      _isDragging = false;
      _isHit = true;
      _lives--;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bahaya! Roket menyentuh Zona Bahaya!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 3: Drag Canvas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'Ke Screen 4',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ScaleSwipeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            color: const Color(0xFFF1F5F9),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Posisi: (${_posX.toStringAsFixed(0)}, ${_posY.toStringAsFixed(0)})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Skor: $_score',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isDragging ? 'Menyeret...' : 'Diam',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Nyawa: $_lives',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxX = constraints.maxWidth - _objectSize;
                final maxY = constraints.maxHeight - _objectSize;

                final targetLeft =
                    constraints.maxWidth - _targetSize - 24;
                final targetTop =
                    constraints.maxHeight - _targetSize - 24;

                final obstacleLeft =
                    (constraints.maxWidth - _obstacleSize) / 2;
                final obstacleTop =
                    (constraints.maxHeight - _obstacleSize) / 2;

                return Stack(
                  children: [
                    const Positioned(
                      top: 14,
                      left: 16,
                      right: 16,
                      child: Text(
                        'Seret roket menuju Drop Zone hijau dan hindari kotak merah!',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                    ),

                    Positioned(
                      left: obstacleLeft,
                      top: obstacleTop,
                      child: Container(
                        width: _obstacleSize,
                        height: _obstacleSize,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          border: Border.all(
                            color: Colors.red,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.red,
                              size: 35,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'ZONA BAHAYA',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      left: targetLeft,
                      top: targetTop,
                      child: Container(
                        width: _targetSize,
                        height: _targetSize,
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFF059669),
                            width: 2.5,
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.flag_circle,
                              color: Color(0xFF059669),
                              size: 34,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'DROP ZONE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF065F46),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_lives <= 0)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black54,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'GAME OVER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _lives = 3;
                                      _score = 0;
                                      _posX = 40;
                                      _posY = 40;
                                      _isHit = false;
                                    });
                                  },
                                  child: const Text('Main Lagi'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      Positioned(
                        left: _posX,
                        top: _posY,
                        child: GestureDetector(
                          onPanStart: (_) {
                            setState(() {
                              _isDragging = true;
                              _isHit = false;
                            });
                          },
                          onPanUpdate: (details) {
                            if (_isHit || _lives <= 0) return;

                            final newX = (_posX + details.delta.dx)
                                .clamp(0.0, maxX)
                                .toDouble();

                            final newY = (_posY + details.delta.dy)
                                .clamp(0.0, maxY)
                                .toDouble();

                            final hitObstacle =
                                newX < obstacleLeft + _obstacleSize &&
                                newX + _objectSize > obstacleLeft &&
                                newY < obstacleTop + _obstacleSize &&
                                newY + _objectSize > obstacleTop;

                            if (hitObstacle) {
                              _resetRocket();
                              return;
                            }

                            setState(() {
                              _posX = newX;
                              _posY = newY;
                            });
                          },
                          onPanEnd: (_) {
                            if (_isHit || _lives <= 0) return;

                            setState(() {
                              _isDragging = false;
                            });

                            final centerX = _posX + _objectSize / 2;
                            final centerY = _posY + _objectSize / 2;

                            final isInsideTarget =
                                centerX >= targetLeft &&
                                centerX <= targetLeft + _targetSize &&
                                centerY >= targetTop &&
                                centerY <= targetTop + _targetSize;

                            if (isInsideTarget) {
                              setState(() {
                                _score += 10;
                                _posX = 40;
                                _posY = 40;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Tepat sasaran! +10 Poin.',
                                  ),
                                ),
                              );
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            width: _objectSize,
                            height: _objectSize,
                            decoration: BoxDecoration(
                              color: _isDragging
                                  ? const Color(0xFF1D4ED8)
                                  : const Color(0xFF2563EB),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(
                                    _isDragging ? 75 : 35,
                                  ),
                                  blurRadius: _isDragging ? 14 : 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.rocket_launch,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
