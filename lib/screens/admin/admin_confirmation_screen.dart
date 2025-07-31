import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:penyewaanbaju/models/rental_history.dart';
import 'package:penyewaanbaju/services/auth_service.dart';
import 'package:penyewaanbaju/widgets/request_card.dart';

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
      appBar: AppBar(
        title: const Text('Konfirmasi Sewa'),
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _authService.getAllRentalRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Error di Admin Confirmation: ${snapshot.error}');
            return const Center(child: Text('Terjadi kesalahan saat memuat data.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada permintaan sewa saat ini.'));
          }

          final rentalDocs = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: rentalDocs.length,
            itemBuilder: (context, index) {
              final rentalData = RentalHistory.fromFirestore(rentalDocs[index]);
              return RequestCard(rental: rentalData);
            },
          );
        },
      ),
    );
  }
}