
import 'package:flutter/material.dart';

// Widget utama untuk halaman Digital Signature
class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {

  // Menyimpan kumpulan titik koordinat coretan jari pengguna
  // Nilai null digunakan untuk memisahkan garis coretan
  List<Offset?> points = [];

  // Menentukan warna pena yang sedang digunakan
  Color selectedColor = Colors.black;

  // Fungsi untuk menghapus seluruh coretan pada kanvas
  void clearCanvas() {
    setState(() {
      points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Membuat AppBar pada bagian atas halaman
      appBar: AppBar(
        title: const Text('Digital Signature'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [

          // Teks petunjuk penggunaan aplikasi
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Gambarlah tanda tangan menggunakan jari Anda!',
              style: TextStyle(fontSize: 16),
            ),
          ),

          // Baris pilihan warna pena
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tombol pilihan warna hitam
              colorButton(Colors.black),

              // Tombol pilihan warna merah
              colorButton(Colors.red),

              // Tombol pilihan warna biru
              colorButton(Colors.blue),
            ],
          ),

          const SizedBox(height: 12),

          // Area kanvas untuk menggambar tanda tangan
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),

              // Mengatur warna, garis tepi, dan bentuk kanvas
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),

              // GestureDetector mendeteksi gerakan jari pengguna
              child: GestureDetector(

                // Dipanggil ketika jari mulai menyentuh dan bergerak
                onPanStart: (details) {
                  setState(() {
                    // Menyimpan posisi awal coretan
                    points.add(details.localPosition);
                  });
                },

                // Dipanggil ketika jari bergerak di atas kanvas
                onPanUpdate: (details) {
                  setState(() {
                    // Menambahkan koordinat baru selama jari bergerak
                    points.add(details.localPosition);
                  });
                },

                // Dipanggil ketika jari berhenti menyentuh layar
                onPanEnd: (details) {
                  setState(() {
                    // Memisahkan coretan agar tidak tersambung
                    // dengan coretan berikutnya
                    points.add(null);
                  });
                },

                // CustomPaint digunakan untuk menggambar garis coretan
                child: CustomPaint(
                  painter: SignaturePainter(
                    points: points,
                    color: selectedColor,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),

          // Tombol untuk menghapus seluruh coretan
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: clearCanvas,
              icon: const Icon(Icons.delete),
              label: const Text('Hapus Kanvas'),

              // Mengatur tampilan tombol hapus
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membuat tombol pilihan warna pena
  Widget colorButton(Color color) {
    return GestureDetector(

      // Mengubah warna pena ketika tombol ditekan
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 40,
        height: 40,

        // Membuat tombol berbentuk lingkaran
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,

          // Memberikan garis oranye pada warna yang sedang dipilih
          border: Border.all(
            color: selectedColor == color
                ? Colors.orange
                : Colors.grey,
            width: selectedColor == color ? 4 : 1,
          ),
        ),
      ),
    );
  }
}

// CustomPainter bertugas menggambar garis tanda tangan pada kanvas
class SignaturePainter extends CustomPainter {

  // Menyimpan koordinat titik-titik coretan
  final List<Offset?> points;

  // Menyimpan warna pena yang digunakan
  final Color color;

  // Constructor untuk menerima data dari SignatureScreen
  SignaturePainter({
    required this.points,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {

    // Mengatur tampilan garis coretan
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Membaca setiap titik koordinat untuk menggambar garis
    for (int i = 0; i < points.length - 1; i++) {

      // Menggambar garis jika kedua titik tidak bernilai null
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!,
          points[i + 1]!,
          paint,
        );
      }
    }
  }

  // Menentukan apakah CustomPainter perlu menggambar ulang
  @override
  bool shouldRepaint(covariant SignaturePainter oldDelegate) {
    return true;
  }
}
