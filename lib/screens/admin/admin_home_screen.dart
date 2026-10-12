import 'package:flutter/material.dart';
import 'package:penyewaanbaju/screens/admin/admin_confirmation_screen.dart';
import 'package:penyewaanbaju/screens/admin/admin_manage_items_screen.dart'; // Pastikan import ini ada
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: Text('Panel Admin', style: AppTheme.heading(20)),
      ),
      body: StudioBackground(
        showGlow: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          children: [
            const SectionHeader(
              title: 'Kendali Studio',
              subtitle: 'Kelola penyewaan & inventaris',
            ),
            _buildAdminMenuItem(
              context,
              icon: Icons.verified_user_outlined,
              title: 'Konfirmasi Ketersediaan',
              subtitle: 'Setujui atau tolak permintaan sewa',
              accent: AppColors.primary,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AdminConfirmationScreen(),
                ));
              },
            ),
            const SizedBox(height: 14),
            _buildAdminMenuItem(
              context,
              icon: Icons.inventory_2_outlined,
              title: 'Kelola Barang',
              subtitle: 'Ubah status ketersediaan barang',
              accent: AppColors.accent,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AdminManageItemsScreen(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    border: Border.all(color: accent.withOpacity(0.3)),
                  ),
                  child: Icon(icon, size: 26, color: accent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTheme.body(16, weight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppTheme.body(12, color: AppColors.textMuted)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
