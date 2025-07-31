import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Navigasi otomatis setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Kembali ke halaman utama (root) setelah animasi selesai
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/Success.json', // Path ke file animasi Anda
              width: 250,
              height: 250,
              repeat: false, // Animasi hanya diputar sekali
            ),
            const SizedBox(height: 20),
            const Text(
              'Penyewaan Berhasil!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}