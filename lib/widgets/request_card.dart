import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penyewaanbaju/models/rental_history.dart';
import 'package:penyewaanbaju/services/auth_service.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';

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
          SnackBar(
            content: Text('Status berhasil diubah menjadi "$newStatus"',
                style: AppTheme.body(13)),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengubah status: $e', style: AppTheme.body(13)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final bool isPending = widget.rental.status == 'Menunggu Konfirmasi';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.rental.costumeName,
                    style: AppTheme.heading(18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                StatusChip(status: widget.rental.status, compact: true),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.calendar_today_rounded, 'Tanggal Sewa',
                '${formatter.format(widget.rental.startDate)} - ${formatter.format(widget.rental.endDate)}'),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.person_rounded, 'Penyewa', widget.rental.userName),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.payments_rounded, 'Total Harga',
                currencyFormatter.format(widget.rental.totalPrice)),
            if (isPending) ...[
              const SizedBox(height: 18),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: const Text('Tolak'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadii.md),
                        ),
                        textStyle: AppTheme.body(14, weight: FontWeight.w600),
                      ),
                      onPressed: () => _updateStatus('Ditolak'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Setujui'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: const Color(0xFF062E28),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadii.md),
                        ),
                        textStyle: AppTheme.body(14, weight: FontWeight.w600),
                      ),
                      onPressed: () => _updateStatus('Disewa'),
                    ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 10),
        Text('$label: ',
            style: AppTheme.body(13, weight: FontWeight.w600, color: AppColors.textSecondary)),
        Expanded(
          child: Text(value,
              style: AppTheme.body(13),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}