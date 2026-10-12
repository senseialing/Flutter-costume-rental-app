import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penyewaanbaju/models/costume.dart';
import 'package:penyewaanbaju/screens/rental_screen.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';

class DetailScreen extends StatelessWidget {
  final Costume costume;

  const DetailScreen({super.key, required this.costume});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(costume.name),
        backgroundColor: AppColors.scaffoldDark.withOpacity(0.6),
        elevation: 0,
      ),
      body: StudioBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Gambar utama ──
              Stack(
                children: [
                  Hero(
                    tag: costume.id,
                    child: Image.network(
                      costume.imageUrl,
                      height: MediaQuery.of(context).size.height * 0.48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: MediaQuery.of(context).size.height * 0.48,
                        color: AppColors.cardDark,
                        child: const Center(
                          child: Icon(Icons.broken_image_rounded, size: 50, color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  ),
                  // Gradien bawah gambar
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 140,
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
              // ── Konten detail ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CategoryTag(
                          label: costume.category,
                          color: costume.category == 'Aksesoris'
                              ? AppColors.accent
                              : AppColors.primary,
                        ),
                        const Spacer(),
                        if (costume.reviewCount > 0)
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppColors.gold, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                costume.rating.toStringAsFixed(1),
                                style: AppTheme.body(13, weight: FontWeight.w700),
                              ),
                              Text(
                                ' (${costume.reviewCount})',
                                style: AppTheme.body(12, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(costume.name, style: AppTheme.heading(26, weight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    // Baris harga dengan gradient text
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppColors.primaryLight, AppColors.primary],
                          ).createShader(bounds),
                          child: Text(
                            currencyFormatter.format(costume.price),
                            style: AppTheme.heading(28, weight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 4),
                          child: Text('/ hari', style: AppTheme.body(13, color: AppColors.textMuted)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Info ukuran
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.straighten_rounded, color: AppColors.accent, size: 20),
                          const SizedBox(width: 12),
                          Text('Ukuran', style: AppTheme.body(12, color: AppColors.textMuted)),
                          const Spacer(),
                          Text(costume.size, style: AppTheme.body(15, weight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Deskripsi', style: AppTheme.heading(18)),
                    const SizedBox(height: 8),
                    Text(
                      costume.description,
                      style: AppTheme.body(14, color: AppColors.textSecondary, height: 1.6),
                    ),
                    const SizedBox(height: 32),
                    // Tombol sewa
                    GradientButton(
                      label: costume.isAvailable ? 'Sewa Sekarang' : 'Tidak Tersedia',
                      icon: costume.isAvailable ? Icons.bolt_rounded : Icons.block_rounded,
                      onPressed: costume.isAvailable
                          ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => RentalScreen(costume: costume),
                          ),
                        );
                      }
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
