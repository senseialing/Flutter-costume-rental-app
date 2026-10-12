import 'package:flutter/material.dart';
import 'package:penyewaanbaju/providers/costume_provider.dart';
import 'package:penyewaanbaju/screens/admin/add_edit_costume_screen.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';
import 'package:provider/provider.dart';

class AdminManageItemsScreen extends StatelessWidget {
  const AdminManageItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CostumeProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: Text('Kelola Barang', style: AppTheme.heading(20)),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : provider.costumes.isEmpty
              ? const EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'Belum ada barang',
                  message: 'Tambahkan kostum pertama ke inventaris studio.',
                )
              : ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        itemCount: provider.costumes.length,
        itemBuilder: (context, index) {
          final costume = provider.costumes[index];
          return _buildItemRow(context, provider, costume);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddEditCostumeScreen(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, CostumeProvider provider, costume) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.sm),
              border: Border.all(color: AppColors.dividerLight),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.sm),
              child: Image.network(
                costume.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.broken_image_rounded, color: AppColors.textMuted),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  costume.name,
                  style: AppTheme.body(15, weight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: costume.isAvailable ? AppColors.success : AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      costume.isAvailable ? 'Tersedia' : 'Tidak Tersedia',
                      style: AppTheme.body(12, weight: FontWeight.w600,
                          color: costume.isAvailable ? AppColors.success : AppColors.error),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: costume.isAvailable,
            onChanged: (newValue) {
              provider.updateAvailability(costume.id, newValue);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.info, size: 20),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddEditCostumeScreen(costume: costume),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Hapus Barang', style: AppTheme.heading(20)),
                  content: Text('Anda yakin ingin menghapus ${costume.name}?',
                      style: AppTheme.body(14)),
                  actions: [
                    TextButton(
                      child: const Text('Batal'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    TextButton(
                      child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
                      onPressed: () {
                        provider.deleteCostume(costume.id);
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
