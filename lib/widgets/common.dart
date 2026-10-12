import 'package:flutter/material.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';

/// ════════════════════════════════════════════════════════════════
///  RAMCOSPLY — Reusable UI kit ("Neo-Tokyo Cosplay Studio")
///  Kumpulan komponen bersama untuk menjaga konsistensi visual di
///  seluruh aplikasi dan menghindari tampilan template/generic.
/// ════════════════════════════════════════════════════════════════

/// Latar belakang dasar aplikasi: near-black + radial glow vermillion
/// di sudut + grid halus. Memberi kedalaman tanpa perlu image asset
/// dan tidak terlihat seperti template.
class StudioBackground extends StatelessWidget {
  final Widget child;
  final bool showGlow;
  const StudioBackground({super.key, required this.child, this.showGlow = true});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.scaffoldDark),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (showGlow) ...[
            // Glow vermillion — pojok kiri atas
            Positioned(
              top: -120,
              left: -80,
              child: _GlowBlob(
                size: 320,
                color: AppColors.primary.withOpacity(0.16),
              ),
            ),
            // Glow cyan — pojok kanan bawah
            Positioned(
              bottom: -140,
              right: -100,
              child: _GlowBlob(
                size: 340,
                color: AppColors.accent.withOpacity(0.10),
              ),
            ),
          ],
          // Grid halus
          const Positioned.fill(child: _GridOverlay()),
          child,
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0)],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

class _GridOverlay extends StatelessWidget {
  const _GridOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter());
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 34.0;
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.018)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Judul section dengan bar aksen di kiri — pengganti heading polos.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.heading(19, weight: FontWeight.w700),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 1),
                  Text(
                    subtitle!,
                    style: AppTheme.body(12, color: AppColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Chip status penyewaan — warna konsisten untuk semua status.
class StatusChip extends StatelessWidget {
  final String status;
  final bool compact;
  const StatusChip({super.key, required this.status, this.compact = false});

  Color get _fg {
    switch (status) {
      case 'Selesai':
        return AppColors.success;
      case 'Disewa':
      case 'Disetujui':
        return AppColors.info;
      case 'Menunggu Konfirmasi':
        return AppColors.warning;
      case 'Ditolak':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _fg;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Text(
        status,
        style: AppTheme.body(
          compact ? 11 : 12,
          weight: FontWeight.w700,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Tag kategori dengan sudut "cut" kiri-atas — elemen khas studio.
class CategoryTag extends StatelessWidget {
  final String label;
  final Color color;
  const CategoryTag({super.key, required this.label, this.color = AppColors.accent});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CutCornerClipper(),
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 14, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.16),
          border: Border(
            left: BorderSide(color: color, width: 2.5),
            top: BorderSide(color: color.withOpacity(0.3)),
            bottom: BorderSide(color: color.withOpacity(0.3)),
            right: BorderSide(color: color.withOpacity(0.3)),
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTheme.heading(11, weight: FontWeight.w700, color: color, letterSpacing: 1),
        ),
      ),
    );
  }
}

class _CutCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const cut = 8.0;
    return Path()
      ..moveTo(cut, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, cut)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Tombol CTA utama dengan gradient signature + shadow lembut.
/// Dipakai hemat agar tidak terlihat seperti template.
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final bool isLoading;
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 54,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(AppRadii.md),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadii.md),
            onTap: enabled ? onPressed : null,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          label,
                          style: AppTheme.body(15, weight: FontWeight.w700, color: Colors.white, letterSpacing: 0.4),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Empty state yang rapi untuk list kosong (history, hasil pencarian).
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.dividerLight),
              ),
              child: Icon(icon, size: 42, color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppTheme.heading(20, weight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTheme.body(13, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

