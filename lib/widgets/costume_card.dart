import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penyewaanbaju/models/costume.dart';
import 'package:penyewaanbaju/screens/detail_screen.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';

class CostumeCard extends StatelessWidget {
  final Costume costume;

  const CostumeCard({super.key, required this.costume});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final categoryColor =
        costume.category == 'Aksesoris' ? AppColors.accent : AppColors.primary;

    return GestureDetector(
      onTap: costume.isAvailable
          ? () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => DetailScreen(costume: costume),
          ),
        );
      }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Bagian gambar ──
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: costume.id,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppRadii.lg),
                        topRight: Radius.circular(AppRadii.lg),
                      ),
                      child: Image.network(
                        costume.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image_rounded,
                                size: 40, color: AppColors.textMuted),
                          );
                        },
                      ),
                    ),
                  ),
                  // Gradien bawah gambar
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 46,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.scaffoldDark.withOpacity(0.75),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badge kategori (pojok kiri atas)
                  Positioned(
                    top: 8,
                    left: 0,
                    child: _CategoryBadge(
                      label: costume.category,
                      color: categoryColor,
                    ),
                  ),
                  // Overlay jika barang tidak tersedia
                  if (!costume.isAvailable)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldDark.withOpacity(0.72),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppRadii.lg),
                            topRight: Radius.circular(AppRadii.lg),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'TIDAK TERSEDIA',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // ── Bagian teks ──
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      costume.name,
                      style: AppTheme.body(14, weight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        if (costume.reviewCount > 0) ...[
                          const Icon(Icons.star_rounded,
                              color: AppColors.gold, size: 15),
                          const SizedBox(width: 3),
                          Text(
                            costume.rating.toStringAsFixed(1),
                            style: AppTheme.body(12, weight: FontWeight.w700),
                          ),
                          Text(
                            ' (${costume.reviewCount})',
                            style: AppTheme.body(11, color: AppColors.textMuted),
                          ),
                        ] else
                          Text(
                            'Baru',
                            style: AppTheme.body(11, color: AppColors.textMuted),
                          ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyFormatter.format(costume.price),
                          style: AppTheme.heading(16,
                              weight: FontWeight.w700, color: AppColors.primary),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2, bottom: 2),
                          child: Text(
                            '/hari',
                            style: AppTheme.body(10, color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge kategori dengan sudut cut kiri — elemen khas di kartu.
class _CategoryBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _CategoryBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CutClipper(),
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 12, top: 4, bottom: 4),
        decoration: BoxDecoration(color: color.withOpacity(0.9)),
        child: Text(
          label.toUpperCase(),
          style: AppTheme.heading(10,
              weight: FontWeight.w700, color: Colors.white, letterSpacing: 0.8),
        ),
      ),
    );
  }
}

class _CutClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const cut = 6.0;
    return Path()
      ..moveTo(cut, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}