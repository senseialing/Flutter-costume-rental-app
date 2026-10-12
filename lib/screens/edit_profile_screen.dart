import 'package:flutter/material.dart';
import 'package:penyewaanbaju/services/auth_service.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';

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
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: Text('Edit Profil', style: AppTheme.heading(20)),
      ),
      body: StudioBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Perbarui Data', style: AppTheme.heading(24)),
                const SizedBox(height: 4),
                Text(
                  'Pastikan informasi kamu selalu up to date.',
                  style: AppTheme.body(13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 28),
                _buildField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  icon: Icons.person_outline_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                _buildField(
                  controller: _alamatController,
                  label: 'Alamat Rumah',
                  icon: Icons.home_work_outlined,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                _buildField(
                  controller: _teleponController,
                  label: 'No. Telephone',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No. telepon tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    : GradientButton(
                        label: 'Simpan Perubahan',
                        icon: Icons.check_rounded,
                        isLoading: _isLoading,
                        onPressed: _saveProfile,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: AppTheme.body(12, color: AppColors.textSecondary, weight: FontWeight.w600),
          ),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTheme.body(14),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
          ),
        ),
      ],
    );
  }
}