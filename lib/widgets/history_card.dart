import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penyewaanbaju/models/rental_history.dart';
import 'package:penyewaanbaju/screens/history_detail_screen.dart';

class HistoryCard extends StatelessWidget {
  final RentalHistory history;
  const HistoryCard({super.key, required this.history});

  // Fungsi helper untuk menentukan warna latar belakang status
  Color _getBackgroundColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green.shade100;
      case 'Disewa':
        return Colors.blue.shade100;
      case 'Menunggu Konfirmasi':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  // Fungsi helper untuk menentukan warna teks status
  Color _getTextColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green.shade800;
      case 'Disewa':
        return Colors.blue.shade800;
      case 'Menunggu Konfirmasi':
        return Colors.orange.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HistoryDetailScreen(history: history),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  history.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 80),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.costumeName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatter.format(history.startDate)} - ${formatter.format(history.endDate)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${history.totalPrice}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(history.status), // Menggunakan fungsi helper
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  history.status,
                  style: TextStyle(
                    color: _getTextColor(history.status), // Menggunakan fungsi helper
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}