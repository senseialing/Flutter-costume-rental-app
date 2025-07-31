import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penyewaanbaju/models/rental_history.dart';
import 'package:penyewaanbaju/services/auth_service.dart';

class RequestCard extends StatefulWidget {
  final RentalHistory rental;
  const RequestCard({super.key, required this.rental});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  final AuthService _authService = AuthService();

  void _updateStatus(String newStatus) async {
    try {
      await _authService.updateRentalStatus(widget.rental.id, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status berhasil diubah menjadi "$newStatus"')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah status: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    final bool isPending = widget.rental.status == 'Menunggu Konfirmasi';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.rental.costumeName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            _buildInfoRow(Icons.calendar_today, 'Tanggal Sewa', '${formatter.format(widget.rental.startDate)} - ${formatter.format(widget.rental.endDate)}'),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.person, 'Penyewa', widget.rental.userName), // Menampilkan nama penyewa
            const SizedBox(height: 8),
            _buildInfoRow(Icons.money, 'Total Harga', 'Rp ${widget.rental.totalPrice}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  widget.rental.status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isPending ? Colors.orange : Colors.green,
                  ),
                ),
              ],
            ),
            if (isPending) ...[
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('Tolak'),
                    onPressed: () => _updateStatus('Ditolak'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Setujui'),
                    onPressed: () => _updateStatus('Disewa'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}