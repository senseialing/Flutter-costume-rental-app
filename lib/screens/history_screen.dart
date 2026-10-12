import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:penyewaanbaju/models/rental_history.dart'; // <-- Pastikan import ini benar
import 'package:penyewaanbaju/widgets/history_card.dart';
import 'package:penyewaanbaju/services/auth_service.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _authService.getRentalHistoryStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (snapshot.hasError) {
          // Tampilkan pesan error yang lebih detail di console
          print('Error di StreamBuilder History: ${snapshot.error}');
          return const EmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Terjadi kesalahan',
            message: 'Gagal memuat riwayat penyewaan.',
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Belum ada riwayat',
            message: 'Yuk sewa kostum pertamamu dan kembalikan jadi legenda!',
          );
        }

        final historyList = snapshot.data!.docs
            .map((doc) => RentalHistory.fromFirestore(doc))
            .toList();

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HistoryCard(history: historyList[index]),
            );
          },
        );
      },
    );
  }
}