import 'package:flutter/material.dart';
import 'package:penyewaanbaju/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _register() async {
    setState(() {
      _isLoading = true;
    });

    final user = await _authService.registerWithEmailPassword(
      _emailController.text,
      _passwordController.text,
      _nameController.text,
      _alamatController.text,
      _teleponController.text,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi gagal. Coba lagi.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
        backgroundColor: Colors.indigo,
      ),
      // PERBAIKAN: Gunakan SingleChildScrollView sebagai root di body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Buat Akun Baru',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Rumah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home_work),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _teleponController,
                decoration: const InputDecoration(
                  labelText: 'No. Telephone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}