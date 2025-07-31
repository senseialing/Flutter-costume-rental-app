import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penyewaanbaju/models/rental_history.dart';

class HistoryDetailScreen extends StatelessWidget {
  final RentalHistory history;
  const HistoryDetailScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Riwayat Sewa'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Gambar Kostum
          Image.network(
            history.imageUrl,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(height: 300, color: Colors.grey[200], child: const Icon(Icons.broken_image, size: 50)),
          ),

          // Semua detail teks
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        history.costumeName,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusBackgroundColor(history.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        history.status,
                        style: TextStyle(
                          color: _getStatusTextColor(history.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),
                _buildDetailRow(Icons.calendar_today_outlined, 'Tanggal Mulai Sewa', dateFormatter.format(history.startDate)),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.calendar_today, 'Tanggal Selesai Sewa', dateFormatter.format(history.endDate)),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.person_outline, 'Nama Penyewa', history.userName),
                const SizedBox(height: 20),
                Card(
                  color: Colors.indigo[50],
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pembayaran',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          currencyFormatter.format(history.totalPrice),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat baris detail
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  // Fungsi helper untuk warna status
  Color _getStatusBackgroundColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green.shade100;
      case 'Disewa':
      case 'Disetujui':
        return Colors.blue.shade100;
      case 'Menunggu Konfirmasi':
        return Colors.orange.shade100;
      case 'Ditolak':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green.shade800;
      case 'Disewa':
      case 'Disetujui':
        return Colors.blue.shade800;
      case 'Menunggu Konfirmasi':
        return Colors.orange.shade800;
      case 'Ditolak':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }
}