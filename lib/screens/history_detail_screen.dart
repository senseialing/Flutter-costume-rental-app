import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penyewaanbaju/models/rental_history.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';

class HistoryDetailScreen extends StatelessWidget {
  final RentalHistory history;
  const HistoryDetailScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: Text('Detail Riwayat', style: AppTheme.heading(20)),
      ),
      body: StudioBackground(
        showGlow: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Gambar Kostum dengan gradien
            Stack(
              children: [
                Image.network(
                  history.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: AppColors.cardDark,
                    child: const Icon(Icons.broken_image_rounded, size: 50, color: AppColors.textMuted),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 120,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.scaffoldDark.withOpacity(0.9),
                          AppColors.scaffoldDark,
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Semua detail teks
            Padding(
              padding: const EdgeInsets.all(20.0),
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
                          style: AppTheme.heading(24),
                        ),
                      ),
                      const SizedBox(width: 10),
                      StatusChip(status: history.status, compact: true),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(Icons.calendar_today_outlined, 'Tanggal Mulai Sewa', dateFormatter.format(history.startDate)),
                  const SizedBox(height: 14),
                  _buildDetailRow(Icons.event_available_rounded, 'Tanggal Selesai Sewa', dateFormatter.format(history.endDate)),
                  const SizedBox(height: 14),
                  _buildDetailRow(Icons.person_outline, 'Nama Penyewa', history.userName),
                  const SizedBox(height: 24),
                  // Kartu total pembayaran
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: AppTheme.body(14, color: AppColors.textSecondary),
                        ),
                        Text(
                          currencyFormatter.format(history.totalPrice),
                          style: AppTheme.heading(20, weight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk membuat baris detail
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(AppRadii.sm),
            border: Border.all(color: AppColors.divider),
          ),
          child: Icon(icon, color: AppColors.accent, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTheme.body(11, color: AppColors.textMuted)),
              const SizedBox(height: 2),
              Text(value, style: AppTheme.body(15, weight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
