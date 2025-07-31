import 'package:flutter/material.dart';
import 'package:penyewaanbaju/screens/admin/admin_confirmation_screen.dart';
import 'package:penyewaanbaju/screens/admin/admin_manage_items_screen.dart'; // Pastikan import ini ada

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Admin'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAdminMenuItem(
            context,
            icon: Icons.check_circle_outline,
            title: 'Konfirmasi Ketersediaan',
            subtitle: 'Setujui atau tolak permintaan sewa',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AdminConfirmationScreen(),
              ));
            },
          ),
          const SizedBox(height: 16),
          // INI ADALAH MENU UNTUK MENGUBAH KETERSEDIAAN
          _buildAdminMenuItem(
            context,
            icon: Icons.inventory_2_outlined,
            title: 'Kelola Barang',
            subtitle: 'Ubah status ketersediaan barang',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AdminManageItemsScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdminMenuItem(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.indigo),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}