import 'package:flutter/material.dart';
import 'package:penyewaanbaju/providers/costume_provider.dart';
import 'package:penyewaanbaju/screens/admin/add_edit_costume_screen.dart';
import 'package:provider/provider.dart';

class AdminManageItemsScreen extends StatelessWidget {
  const AdminManageItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CostumeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Barang'),
        backgroundColor: Colors.indigo,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: provider.costumes.length,
        itemBuilder: (context, index) {
          final costume = provider.costumes[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(costume.imageUrl),
              ),
              title: Text(costume.name),
              subtitle: Text(costume.isAvailable ? 'Tersedia' : 'Tidak Tersedia', style: TextStyle(color: costume.isAvailable ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),

              // --- PERUBAHAN UTAMA DI SINI ---
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. TOMBOL SWITCH KETERSEDIAAN DIKEMBALIKAN
                  Switch(
                    value: costume.isAvailable,
                    onChanged: (newValue) {
                      provider.updateAvailability(costume.id, newValue);
                    },
                    activeColor: Colors.green,
                  ),
                  // 2. TOMBOL EDIT
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddEditCostumeScreen(costume: costume),
                      ));
                    },
                  ),
                  // 3. TOMBOL HAPUS
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Konfirmasi'),
                          content: Text('Anda yakin ingin menghapus ${costume.name}?'),
                          actions: [
                            TextButton(
                              child: const Text('Batal'),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                            TextButton(
                              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
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
              // --- BATAS PERUBAHAN ---
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddEditCostumeScreen(),
          ));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}