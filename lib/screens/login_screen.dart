import 'dart:ui'; // Import untuk efek blur (ImageFilter)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import untuk font kustom
import 'package:penyewaanbaju/screens/home_screen.dart';
import 'package:penyewaanbaju/screens/register_screen.dart';
import 'package:penyewaanbaju/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    // Fungsi login ini tidak diubah sama sekali
    setState(() {
      _isLoading = true;
    });

    final user = await _authService.signInWithEmailPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Login gagal. Periksa kembali email dan password Anda.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Stack untuk menumpuk background dan konten
      body: Stack(
        children: [
          // 1. GAMBAR LATAR BELAKANG ANIME
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Pastikan nama file ini sesuai dengan file Anda
                image: AssetImage('assets/images/login_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. KONTEN LOGIN (DIBUAT BISA SCROLL)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Judul dengan font elegan
                  Text(
                    'RAMCOSPLY',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 60,
                      color: Colors.white,
                      letterSpacing: 4,
                      shadows: [
                        const Shadow(color: Colors.black54, blurRadius: 15, offset: Offset(2, 2)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Selamat datang kembali!',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      color: Colors.white,
                      shadows: [
                        const Shadow(color: Colors.black87, blurRadius: 5),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Container dengan efek "Glassmorphism"
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Input field Email
                            _buildTextField(
                              controller: _emailController,
                              hintText: 'Email',
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20),
                            // Input field Password
                            _buildTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),
                            const SizedBox(height: 30),
                            // Tombol Login
                            _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyanAccent,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text('Login', style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tombol ke halaman Register
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: Text(
                      'Belum punya akun? Daftar di sini',
                      style: GoogleFonts.lato(color: Colors.white, shadows: [const Shadow(color: Colors.black87, blurRadius: 5)]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat TextField yang elegan
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: isPassword
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    );
  }
}