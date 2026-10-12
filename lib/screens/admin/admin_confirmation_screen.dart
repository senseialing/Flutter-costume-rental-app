import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:penyewaanbaju/models/rental_history.dart';
import 'package:penyewaanbaju/services/auth_service.dart';
import 'package:penyewaanbaju/widgets/request_card.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';

class AdminConfirmationScreen extends StatefulWidget {
  const AdminConfirmationScreen({super.key});

  @override
  State<AdminConfirmationScreen> createState() => _AdminConfirmationScreenState();
}

class _AdminConfirmationScreenState extends State<AdminConfirmationScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: Text('Konfirmasi Sewa', style: AppTheme.heading(20)),
      ),
      body: StudioBackground(
        showGlow: false,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _authService.getAllRentalRequests(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            if (snapshot.hasError) {
              print('Error di Admin Confirmation: ${snapshot.error}');
              return const EmptyState(
                icon: Icons.error_outline_rounded,
                title: 'Terjadi kesalahan',
                message: 'Gagal memuat data permintaan sewa.',
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const EmptyState(
                icon: Icons.inbox_rounded,
                title: 'Tidak ada permintaan',
                message: 'Belum ada permintaan sewa yang perlu dikonfirmasi.',
              );
            }

            final rentalDocs = snapshot.data!.docs;
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: rentalDocs.length,
              itemBuilder: (context, index) {
                final rentalData = RentalHistory.fromFirestore(rentalDocs[index]);
                return RequestCard(rental: rentalData);
              },
            );
          },
        ),
      ),
    );
  }
}
