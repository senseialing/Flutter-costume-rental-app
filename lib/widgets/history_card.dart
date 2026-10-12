import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penyewaanbaju/models/rental_history.dart';
import 'package:penyewaanbaju/screens/history_detail_screen.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';

class HistoryCard extends StatelessWidget {
  final RentalHistory history;
  const HistoryCard({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.lg),
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
                // Gambar kostum dengan border aksen
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                    border: Border.all(color: AppColors.dividerLight),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                    child: Image.network(
                      history.imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image_rounded, size: 72, color: AppColors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        history.costumeName,
                        style: AppTheme.body(15, weight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.textMuted),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              '${formatter.format(history.startDate)} - ${formatter.format(history.endDate)}',
                              style: AppTheme.body(11, color: AppColors.textMuted),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currencyFormatter.format(history.totalPrice),
                        style: AppTheme.heading(16, weight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusChip(status: history.status, compact: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
