import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:penyewaanbaju/models/rental_history.dart'; // <-- Pastikan import ini benar
import 'package:penyewaanbaju/widgets/history_card.dart';
import 'package:penyewaanbaju/services/auth_service.dart';

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
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (snapshot.hasError) {
          // Tampilkan pesan error yang lebih detail di console
          print('Error di StreamBuilder History: ${snapshot.error}');
          return const Center(child: Text('Terjadi kesalahan', style: TextStyle(color: Colors.white)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada riwayat penyewaan.',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          );
        }

        final historyList = snapshot.data!.docs
            .map((doc) => RentalHistory.fromFirestore(doc))
            .toList();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              return HistoryCard(history: historyList[index]);
            },
          ),
        );
      },
    );
  }
}