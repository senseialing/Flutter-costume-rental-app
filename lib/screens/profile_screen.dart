import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:penyewaanbaju/services/auth_service.dart';
import 'package:penyewaanbaju/screens/edit_profile_screen.dart';
import 'package:penyewaanbaju/screens/admin/admin_home_screen.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';

class ProfileScreen extends StatefulWidget {
  // Menerima fungsi onLogout
  final VoidCallback onLogout;
  const ProfileScreen({super.key, required this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _authService.getUserDataStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (snapshot.hasError) {
          return const EmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Terjadi kesalahan',
            message: 'Gagal memuat data profil. Coba lagi nanti.',
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const EmptyState(
            icon: Icons.person_off_outlined,
            title: 'Profil tidak ditemukan',
            message: 'Tidak dapat memuat data profil Anda.',
          );
        }

        final userData = snapshot.data!.data();
        final String nama = userData?['nama'] ?? 'Belum diisi';
        final String email = userData?['email'] ?? 'Belum diisi';
        final String alamat = userData?['alamat'] ?? 'Belum diisi';
        final String telepon = userData?['telepon'] ?? 'Belum diisi';
        final bool isAdmin = userData?['isAdmin'] ?? false;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              // ── Avatar dengan ring aksen ──
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 52,
                        backgroundColor: AppColors.cardDark,
                        child: Icon(Icons.person_rounded, size: 52, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(nama, style: AppTheme.heading(24)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAdmin
                            ? AppColors.gold.withOpacity(0.15)
                            : AppColors.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isAdmin
                              ? AppColors.gold.withOpacity(0.5)
                              : AppColors.accent.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        isAdmin ? 'ADMINISTRATOR' : 'MEMBER COSPLAYER',
                        style: AppTheme.body(10, weight: FontWeight.w700,
                            color: isAdmin ? AppColors.gold : AppColors.accent, letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // ── Info card ──
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildInfoTile(Icons.person_outline_rounded, 'Nama Lengkap', nama, AppColors.primary),
                    _divider(),
                    _buildInfoTile(Icons.alternate_email_rounded, 'Email', email, AppColors.accent),
                    _divider(),
                    _buildInfoTile(Icons.home_work_outlined, 'Alamat Rumah', alamat, AppColors.info),
                    _divider(),
                    _buildInfoTile(Icons.phone_rounded, 'No. Telephone', telepon, AppColors.success),
                  ],
                ),
              ),
              const SizedBox(height: 24),
                // Tombol Edit Profil
                GradientButton(
                  label: 'Edit Profil',
                  icon: Icons.edit_rounded,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        currentName: nama,
                        currentAlamat: alamat,
                        currentTelepon: telepon,
                      ),
                    ));
                  },
                ),
                const SizedBox(height: 12),

                // Tombol Panel Admin
                if (isAdmin) ...[
                  _buildActionButton(
                    icon: Icons.admin_panel_settings_rounded,
                    label: 'Panel Admin',
                    color: AppColors.gold,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AdminHomeScreen(),
                      ));
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // Tombol Logout
                _buildActionButton(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  color: AppColors.error,
                  onPressed: widget.onLogout,
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 54,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle: AppTheme.body(15, weight: FontWeight.w600),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value, Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadii.sm),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTheme.body(11, color: AppColors.textMuted)),
                const SizedBox(height: 2),
                Text(value, style: AppTheme.body(15, weight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(
        height: 1,
        indent: 64,
        endIndent: 12,
        color: AppColors.divider,
      );
}