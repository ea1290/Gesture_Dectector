
import 'package:flutter/material.dart';

// Screen 4 untuk fitur Pinch, Zoom, Rotation, dan Swipe
class ScaleSwipeScreen extends StatefulWidget {
  const ScaleSwipeScreen({super.key});

  @override
  State<ScaleSwipeScreen> createState() => _ScaleSwipeScreenState();
}

class _ScaleSwipeScreenState extends State<ScaleSwipeScreen>
    with SingleTickerProviderStateMixin {

  // ================= VARIABEL MODE GALERI =================

  // Menyimpan indeks kartu galeri yang sedang ditampilkan
  int _currentIndex = 0;

  // Menyimpan ukuran gambar saat diperbesar atau diperkecil
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Menyimpan sudut rotasi gambar
  double _currentRotation = 0.0;
  double _baseRotation = 0.0;

  // Menentukan mode yang sedang ditampilkan
  // false = Mode Galeri, true = Mode Keputusan
  bool _showDecisionCards = false;

  // ================= VARIABEL MODE KEPUTUSAN =================

  // Menyimpan indeks kartu keputusan yang sedang ditampilkan
  int _decisionIndex = 0;

  // Menyimpan posisi kartu ketika digeser
  Offset _dragOffset = Offset.zero;

  // Menyimpan posisi awal animasi
  Offset _animationStartOffset = Offset.zero;

  // Menyimpan posisi akhir animasi
  Offset _animationTargetOffset = Offset.zero;

  // Menentukan apakah animasi sedang berjalan
  bool _isAnimating = false;

  // Batas minimal pergeseran kartu adalah 120 piksel
  static const double _swipeThreshold = 120.0;

  // Controller untuk mengatur animasi kartu
  late AnimationController _controller;

  // ================= DATA KARTU GALERI =================

  // Daftar kartu untuk fitur galeri
  final List<Map<String, dynamic>> _galleryItems = const [
    {
      'title': 'Eksplorasi Pegunungan',
      'tag': 'KARTU 1 / 3',
      'desc': 'Gunakan dua jari (pinch) untuk memperbesar atau memutar kartu ini.',
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
      'desc': 'Tekan tombol Reset Transformasi untuk mengembalikan skala ke 1.0x.',
      'icon': Icons.auto_awesome,
      'color': Color(0xFF6D28D9),
    },
  ];

  // ================= DATA KARTU KEPUTUSAN =================

  // Daftar kartu tambahan untuk tugas Swipeable Decision Cards
  final List<Map<String, dynamic>> _decisionItems = const [
    {
      'title': 'Pegunungan',
      'description': 'Pemandangan alam yang indah dan menenangkan.',
      'icon': Icons.terrain,
      'color': Color(0xFF0F766E),
    },
    {
      'title': 'Arsitektur Modern',
      'description': 'Bangunan modern dengan desain yang menarik.',
      'icon': Icons.location_city,
      'color': Color(0xFF1D4ED8),
    },
    {
      'title': 'Antariksa',
      'description': 'Jelajahi keindahan luar angkasa.',
      'icon': Icons.auto_awesome,
      'color': Color(0xFF6D28D9),
    },
    {
      'title': 'Lautan',
      'description': 'Keindahan laut dan kehidupan bawah air.',
      'icon': Icons.water,
      'color': Color(0xFF0891B2),
    },
    {
      'title': 'Hutan',
      'description': 'Nikmati suasana hutan yang asri.',
      'icon': Icons.forest,
      'color': Color(0xFF15803D),
    },
  ];

  // ================= INISIALISASI ANIMASI =================

  @override
  void initState() {
    super.initState();

    // Membuat controller dengan durasi animasi 300 milidetik
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Memperbarui posisi kartu selama animasi berlangsung
    _controller.addListener(() {
      setState(() {
        _dragOffset = Offset.lerp(
          _animationStartOffset,
          _animationTargetOffset,

          // Menggunakan easeOut agar animasi lebih halus
          Curves.easeOut.transform(_controller.value),
        )!;
      });
    });

    // Menjalankan perintah setelah animasi selesai
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          // Berpindah ke kartu keputusan berikutnya
          _decisionIndex++;

          // Mengembalikan posisi kartu ke tengah
          _dragOffset = Offset.zero;

          // Menandakan animasi telah selesai
          _isAnimating = false;
        });

        // Mengatur ulang controller untuk animasi berikutnya
        _controller.reset();
      }
    });
  }

  // ================= FUNGSI MODE GALERI =================

  // Mengembalikan ukuran dan rotasi gambar ke kondisi awal
  void _resetTransform() {
    setState(() {
      _currentScale = 1.0;
      _baseScale = 1.0;
      _currentRotation = 0.0;
      _baseRotation = 0.0;
    });
  }

  // Berpindah ke kartu galeri berikutnya
  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _galleryItems.length;

      // Mengatur ulang ukuran dan rotasi gambar
      _currentScale = 1.0;
      _baseScale = 1.0;
      _currentRotation = 0.0;
      _baseRotation = 0.0;
    });
  }

  // Berpindah ke kartu galeri sebelumnya
  void _prevCard() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _galleryItems.length) %
              _galleryItems.length;

      // Mengatur ulang ukuran dan rotasi gambar
      _currentScale = 1.0;
      _baseScale = 1.0;
      _currentRotation = 0.0;
      _baseRotation = 0.0;
    });
  }

  // ================= FUNGSI MODE KEPUTUSAN =================

  // Menjalankan animasi untuk melempar kartu keluar layar
  // direction 1 = kanan, direction -1 = kiri
  void _startDecisionSwipe(double direction) {

    // Mencegah animasi dijalankan berulang kali
    // ketika animasi sebelumnya belum selesai
    if (_isAnimating ||
        _decisionIndex >= _decisionItems.length) {
      return;
    }

    setState(() {
      _isAnimating = true;

      // Menyimpan posisi kartu saat ini
      _animationStartOffset = _dragOffset;

      // Menentukan arah lemparan kartu
      // Nilai 1000 membuat kartu bergerak keluar layar
      _animationTargetOffset = Offset(
        direction * 1000,
        _dragOffset.dy,
      );
    });

    // Memulai animasi dari awal
    _controller.forward(from: 0);
  }

  // Mengembalikan seluruh kartu keputusan ke kondisi awal
  void _resetDecisionCards() {
    setState(() {
      _decisionIndex = 0;
      _dragOffset = Offset.zero;
      _isAnimating = false;
    });

    // Mengatur ulang controller animasi
    _controller.reset();
  }

  // Menghapus controller ketika halaman ditutup
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ================= TAMPILAN UTAMA =================

  @override
  Widget build(BuildContext context) {

    // Mengambil data kartu galeri berdasarkan indeks
    final item = _galleryItems[_currentIndex];

    // Mengambil warna kartu galeri
    final Color cardColor = item['color'] as Color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 4: Pinch & Swipe'),

        // Tombol untuk kembali ke halaman HomeScreen
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // ================= PILIHAN MODE =================

            // Tombol untuk berpindah antara Mode Galeri dan Keputusan
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showDecisionCards = false;
                      });
                    },

                    // Mengubah warna tombol sesuai mode aktif
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_showDecisionCards
                          ? const Color(0xFF1B365D)
                          : Colors.grey.shade300,
                      foregroundColor: !_showDecisionCards
                          ? Colors.white
                          : Colors.black,
                    ),
                    child: const Text('Mode Galeri'),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showDecisionCards = true;
                      });
                    },

                    // Mengubah warna tombol sesuai mode aktif
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showDecisionCards
                          ? const Color(0xFF1B365D)
                          : Colors.grey.shade300,
                      foregroundColor: _showDecisionCards
                          ? Colors.white
                          : Colors.black,
                    ),
                    child: const Text('Mode Keputusan'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Menampilkan tampilan sesuai mode yang dipilih
            if (!_showDecisionCards) ...[

              // ================= MODE GALERI =================
              // Bagian ini mempertahankan fitur asli

              // Menampilkan informasi skala, rotasi, dan tombol reset
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      'Rotasi: ${(_currentRotation * 57.2958).toStringAsFixed(0)}°',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Tombol untuk mengembalikan transformasi
                    TextButton(
                      onPressed: _resetTransform,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),

              // Area kartu galeri yang dapat diperbesar dan diputar
              Expanded(
                child: Center(
                  child: GestureDetector(

                    // Mendeteksi awal gerakan dua jari
                    onScaleStart: (details) {
                      _baseScale = _currentScale;
                      _baseRotation = _currentRotation;
                    },

                    // Memperbarui ukuran dan rotasi gambar
                    onScaleUpdate: (details) {
                      setState(() {
                        // Mengatur batas ukuran gambar
                        _currentScale =
                            (_baseScale * details.scale)
                                .clamp(0.6, 2.2)
                                .toDouble();

                        // Menghitung sudut rotasi gambar
                        _currentRotation =
                            _baseRotation + details.rotation;
                      });
                    },

                    // Memutar dan memperbesar kartu
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

                          // Isi kartu galeri
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

                              // Ikon kartu galeri
                              Icon(
                                item['icon'] as IconData,
                                size: 76,
                                color: Colors.white,
                              ),

                              const SizedBox(height: 18),

                              // Judul kartu
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

                              // Deskripsi kartu
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

              // Area swipe galeri asli
              GestureDetector(
                onHorizontalDragEnd: (details) {

                  // Memeriksa kecepatan geseran
                  if (details.primaryVelocity == null) return;

                  // Jika digeser ke kiri, tampilkan kartu berikutnya
                  if (details.primaryVelocity! < -200) {
                    _nextCard();

                  // Jika digeser ke kanan, tampilkan kartu sebelumnya
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

                      // Indikator titik untuk menunjukkan kartu aktif
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

                      // Petunjuk untuk mengganti kartu galeri
                      const Text(
                        '← Usap (Swipe) Kiri atau Kanan di Area Ini untuk Ganti Kartu →',
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

            ] else ...[

              // ================= MODE KEPUTUSAN =================
              // Bagian tambahan untuk tugas Swipeable Decision Cards

              const Text(
                'Swipeable Decision Cards',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              // Menampilkan nomor kartu yang sedang aktif
              Text(
                _decisionIndex >= _decisionItems.length
                    ? 'Semua kartu telah selesai!'
                    : 'Kartu ${_decisionIndex + 1} dari ${_decisionItems.length}',
                style: const TextStyle(color: Colors.grey),
              ),

              // Area untuk menampilkan kartu keputusan
              Expanded(
                child: Center(
                  child: _decisionIndex >= _decisionItems.length

                      // Tampilan ketika seluruh kartu telah selesai
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 80,
                              color: Colors.green,
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              'Semua Kartu Selesai!',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Tombol untuk mengulangi semua kartu
                            ElevatedButton(
                              onPressed: _resetDecisionCards,
                              child: const Text('Ulangi'),
                            ),
                          ],
                        )

                      // Kartu yang dapat digeser menggunakan GestureDetector
                      : GestureDetector(

                          // Mendeteksi pergerakan kartu ketika diseret
                          onPanUpdate: (details) {
                            if (_isAnimating) return;

                            setState(() {
                              // Memperbarui posisi kartu sesuai gerakan jari
                              _dragOffset += details.delta;
                            });
                          },

                          // Memeriksa posisi kartu ketika jari dilepaskan
                          onPanEnd: (details) {
                            if (_isAnimating) return;

                            // Jika digeser ke kanan lebih dari 120 piksel
                            if (_dragOffset.dx > _swipeThreshold) {
                              _startDecisionSwipe(1);

                            // Jika digeser ke kiri lebih dari 120 piksel
                            } else if (_dragOffset.dx <
                                -_swipeThreshold) {
                              _startDecisionSwipe(-1);

                            } else {
                              // Jika belum melewati batas,
                              // kartu kembali ke posisi tengah
                              setState(() {
                                _dragOffset = Offset.zero;
                              });
                            }
                          },

                          // Menggeser posisi kartu sesuai koordinat
                          child: Transform.translate(
                            offset: _dragOffset,

                            // Membuat kartu sedikit miring saat digeser
                            child: Transform.rotate(
                              angle: _dragOffset.dx * 0.001,
                              child: _buildDecisionCard(),
                            ),
                          ),
                        ),
                ),
              ),

              // Tombol keputusan manual di bawah kartu
              if (_decisionIndex < _decisionItems.length)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    // Tombol LEWATI untuk melempar kartu ke kiri
                    ElevatedButton.icon(
                      onPressed: _isAnimating
                          ? null
                          : () => _startDecisionSwipe(-1),
                      icon: const Icon(Icons.close),
                      label: const Text('LEWATI'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                    ),

                    // Tombol SETUJU untuk melempar kartu ke kanan
                    ElevatedButton.icon(
                      onPressed: _isAnimating
                          ? null
                          : () => _startDecisionSwipe(1),
                      icon: const Icon(Icons.check),
                      label: const Text('SETUJU'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              // Petunjuk penggunaan fitur swipe keputusan
              const Text(
                'Geser kartu ke kiri atau kanan melewati 120 piksel.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================= TAMPILAN KARTU KEPUTUSAN =================

  // Membuat tampilan kartu untuk Mode Keputusan
  Widget _buildDecisionCard() {

    // Mengambil data kartu berdasarkan indeks
    final card = _decisionItems[_decisionIndex];

    // Menghitung transparansi label berdasarkan jarak geseran
    final double opacity =
        (_dragOffset.dx.abs() / _swipeThreshold)
            .clamp(0.0, 1.0);

    // Menentukan apakah kartu digeser ke kanan
    final bool isAgree = _dragOffset.dx > 0;

    return Container(
      width: 290,
      height: 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: card['color'] as Color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      // Stack digunakan agar label dapat berada di atas kartu
      child: Stack(
        children: [

          // Isi utama kartu keputusan
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Ikon kartu
                Icon(
                  card['icon'] as IconData,
                  size: 90,
                  color: Colors.white,
                ),

                const SizedBox(height: 25),

                // Judul kartu
                Text(
                  card['title'] as String,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                // Deskripsi kartu
                Text(
                  card['description'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Menampilkan label ketika kartu mulai digeser
          if (_dragOffset.dx.abs() > 10)
            Positioned(
              top: 20,

              // Posisi label menyesuaikan arah geseran
              left: isAgree ? null : 0,
              right: isAgree ? 0 : null,

              child: Opacity(
                opacity: opacity,
                child: Transform.rotate(
                  angle: isAgree ? -0.2 : 0.2,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isAgree
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    // Teks label berubah sesuai arah geseran
                    child: Text(
                      isAgree ? 'SETUJU' : 'LEWATI',
                      style: TextStyle(
                        color: isAgree
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
