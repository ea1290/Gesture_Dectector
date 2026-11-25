
import 'package:flutter/material.dart';
import 'tap_gesture_screen.dart';
import 'drag_canvas_screen.dart';
import 'signature_screen.dart';
import 'scale_swipe_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GesturLab'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pelajari berbagai interaksi gestur pada Flutter.',
            ),
            const SizedBox(height: 25),
            const Text(
              'Daftar Praktikum',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            _buildMenu(
              context,
              'Screen 2',
              'Tap, Double Tap & Long Press',
              Icons.touch_app,
            ),

            _buildMenu(
              context,
              'Screen 3',
              'Drag & Drop Canvas',
              Icons.open_with,
            ),

            _buildMenu(
              context,
              'Screen 4',
              'Pinch-to-Zoom & Swipe',
              Icons.pinch,
            ),

            _buildMenu(
              context,
              'Screen 5',
              'Signature Canvas',
              Icons.draw,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
  if (title == 'Screen 2') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TapGestureScreen(),
      ),
    );
  } else if (title == 'Screen 3') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DragCanvasScreen(),
      ),
    );
  } else if (title == 'Screen 4') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ScaleSwipeScreen(),
      ),
    );
  } else if (title == 'Screen 5') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SignatureScreen(),
      ),
    );
  }
},
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: Text(subtitle),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Tutup'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: const Color(0xFF1B365D),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
