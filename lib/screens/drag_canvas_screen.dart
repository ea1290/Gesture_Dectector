
import 'package:flutter/material.dart';
import 'scale_swipe_screen.dart';

class DragCanvasScreen extends StatefulWidget {
  const DragCanvasScreen({super.key});

  @override
  State<DragCanvasScreen> createState() => _DragCanvasScreenState();
}

class _DragCanvasScreenState extends State<DragCanvasScreen> {
  double _posX = 40.0;
  double _posY = 40.0;
  bool _isDragging = false;
  bool _hitObstacle = false;
  int _score = 0;

  static const double _objectSize = 72.0;
  static const double _targetSize = 110.0;
  static const double _obstacleSize = 100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 3: Drag & Pan Canvas'),
        actions: [
          IconButton(
            tooltip: 'Ke Screen 4 (Pinch & Swipe)',
            icon: const Icon(Icons.arrow_forward),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            color: const Color(0xFFF1F5F9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Posisi: (${_posX.toStringAsFixed(0)}, ${_posY.toStringAsFixed(0)})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                Text(
                  _isDragging
                      ? 'Status: Menyeret...'
                      : 'Status: Diam',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    color: _isDragging
                        ? const Color(0xFF059669)
                        : const Color(0xFF64748B),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B365D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Skor: $_score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

                // Posisi Zona Bahaya di tengah kanvas
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
                        'Seret roket ke Zona Target hijau. Hindari Zona Bahaya merah!',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                    ),

                    // Zona Bahaya
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
                              Icons.warning_rounded,
                              color: Colors.red,
                              size: 36,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'ZONA BAHAYA',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Zona Target
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

                    // Objek Roket
                    Positioned(
                      left: _posX,
                      top: _posY,
                      child: GestureDetector(
                        onPanStart: (_) {
                          setState(() {
                            _isDragging = true;
                            _hitObstacle = false;
                          });
                        },

                        onPanUpdate: (details) {
                          if (_hitObstacle) return;

                          final nextX = (_posX + details.delta.dx)
                              .clamp(0.0, maxX);

                          final nextY = (_posY + details.delta.dy)
                              .clamp(0.0, maxY);

                          // Pemeriksaan tabrakan dengan Zona Bahaya
                          final isCollision =
                              nextX < obstacleLeft + _obstacleSize &&
                              nextX + _objectSize > obstacleLeft &&
                              nextY < obstacleTop + _obstacleSize &&
                              nextY + _objectSize > obstacleTop;

                          if (isCollision) {
                            setState(() {
                              _posX = 40.0;
                              _posY = 40.0;
                              _isDragging = false;
                              _hitObstacle = true;
                            });

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Peringatan! Roket menyentuh Zona Bahaya!',
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );

                            return;
                          }

                          setState(() {
                            _posX = nextX;
                            _posY = nextY;
                          });
                        },

                        onPanEnd: (_) {
                          if (_hitObstacle) return;

                          setState(() {
                            _isDragging = false;
                          });

                          final centerX = _posX + (_objectSize / 2);
                          final centerY = _posY + (_objectSize / 2);

                          final isInsideTarget =
                              centerX >= targetLeft &&
                              centerX <= targetLeft + _targetSize &&
                              centerY >= targetTop &&
                              centerY <= targetTop + _targetSize;

                          if (isInsideTarget) {
                            setState(() {
                              _score += 10;
                              _posX = 40.0;
                              _posY = 40.0;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tepat sasaran! +10 Poin.'),
                                duration: Duration(seconds: 1),
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
