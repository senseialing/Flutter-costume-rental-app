import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:penyewaanbaju/services/auth_service.dart';
import 'package:penyewaanbaju/screens/edit_profile_screen.dart';
import 'package:penyewaanbaju/screens/admin/admin_home_screen.dart';

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
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Terjadi kesalahan', style: TextStyle(color: Colors.white)));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Tidak dapat memuat data profil', style: TextStyle(color: Colors.white)));
        }

        final userData = snapshot.data!.data();
        final String nama = userData?['nama'] ?? 'Belum diisi';
        final String email = userData?['email'] ?? 'Belum diisi';
        final String alamat = userData?['alamat'] ?? 'Belum diisi';
        final String telepon = userData?['telepon'] ?? 'Belum diisi';
        final bool isAdmin = userData?['isAdmin'] ?? false;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 80, color: Colors.indigo),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline, color: Colors.indigo),
                          title: Text(nama, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: const Text('Nama Lengkap'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.email_outlined, color: Colors.indigo),
                          title: Text(email, style: const TextStyle(fontSize: 16)),
                          subtitle: const Text('Email'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.home_work_outlined, color: Colors.indigo),
                          title: Text(alamat, style: const TextStyle(fontSize: 16)),
                          subtitle: const Text('Alamat Rumah'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.phone_outlined, color: Colors.indigo),
                          title: Text(telepon, style: const TextStyle(fontSize: 16)),
                          subtitle: const Text('No. Telephone'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profil'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
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
                if (isAdmin)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.admin_panel_settings),
                    label: const Text('Panel Admin'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AdminHomeScreen(),
                      ));
                    },
                  ),

                // --- PERUBAHAN: Tombol Logout dipindahkan ke sini ---
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.redAccent, // Warna berbeda
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: widget.onLogout, // Memanggil fungsi logout
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}