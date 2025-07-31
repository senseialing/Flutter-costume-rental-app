import 'package:flutter/material.dart';
import 'package:penyewaanbaju/services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  // PERUBAHAN: Menerima data alamat dan telepon
  final String currentName;
  final String currentAlamat;
  final String currentTelepon;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentAlamat,
    required this.currentTelepon,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  // --- TAMBAHAN ---
  late final TextEditingController _alamatController;
  late final TextEditingController _teleponController;

  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    // --- TAMBAHAN ---
    _alamatController = TextEditingController(text: widget.currentAlamat);
    _teleponController = TextEditingController(text: widget.currentTelepon);
  }

  @override
  void dispose() {
    _nameController.dispose();
    // --- TAMBAHAN ---
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // PERUBAHAN: Memanggil fungsi update yang baru
        await _authService.updateUserProfile(
          _nameController.text,
          _alamatController.text,
          _teleponController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui!')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui profil: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // --- TAMBAHAN: Form Alamat ---
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Rumah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home_work),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // --- TAMBAHAN: Form Telepon ---
              TextFormField(
                controller: _teleponController,
                decoration: const InputDecoration(
                  labelText: 'No. Telephone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No. telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Simpan Perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}