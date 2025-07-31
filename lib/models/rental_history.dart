import 'package:cloud_firestore/cloud_firestore.dart';

class RentalHistory {
  final String id;
  final String costumeName;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final int totalPrice;
  final String status;
  final String userName;

  RentalHistory({
    required this.id,
    required this.costumeName,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.userName,
  });

  // --- PERBAIKAN UTAMA ADA DI FUNGSI INI ---
  factory RentalHistory.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    // Fungsi kecil untuk mengubah data tanggal dengan aman
    DateTime parseDate(dynamic dateValue) {
      if (dateValue is Timestamp) {
        // Jika datanya sudah benar (Timestamp), langsung ubah
        return dateValue.toDate();
      } else if (dateValue is String) {
        // Jika datanya salah (String), coba ubah menjadi tanggal
        return DateTime.tryParse(dateValue) ?? DateTime.now();
      }
      // Jika tidak ada data, gunakan tanggal hari ini sebagai default
      return DateTime.now();
    }

    return RentalHistory(
      id: doc.id,
      costumeName: data['costumeName'] ?? 'Nama Tidak Ada',
      imageUrl: data['imageUrl'] ?? '',
      // Menggunakan fungsi aman untuk membaca tanggal
      startDate: parseDate(data['startDate']),
      endDate: parseDate(data['endDate']),
      totalPrice: data['totalPrice'] ?? 0,
      status: data['status'] ?? 'Selesai',
      userName: data['userName'] ?? 'Pengguna Tidak Dikenal',
    );
  }
}