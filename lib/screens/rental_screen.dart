import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penyewaanbaju/models/costume.dart';
import 'package:penyewaanbaju/providers/costume_provider.dart';
import 'package:penyewaanbaju/services/auth_service.dart';
import 'package:penyewaanbaju/screens/success_screen.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';
import 'package:provider/provider.dart';

class RentalScreen extends StatefulWidget {
  final Costume costume;
  const RentalScreen({super.key, required this.costume});

  @override
  State<RentalScreen> createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormatter = DateFormat('dd MMMM yyyy');
  final AuthService _authService = AuthService();
  bool _isSaving = false;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: isStartDate ? DateTime.now() : _startDate!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && picked.isAfter(_endDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  int _calculateRentalDays() {
    if (_startDate != null &&
        _endDate != null &&
        (_endDate!.isAfter(_startDate!) ||
            _endDate!.isAtSameMomentAs(_startDate!))) {
      return _endDate!.difference(_startDate!).inDays + 1;
    }
    return 0;
  }

  int _calculateTotalPrice() {
    final rentalDays = _calculateRentalDays();
    if (rentalDays > 0) {
      return rentalDays * widget.costume.price;
    }
    return 0;
  }

  void _confirmRental() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Silakan pilih tanggal mulai dan selesai sewa.')),
      );
      return;
    }

    final totalDays = _calculateRentalDays();
    final totalPrice = _calculateTotalPrice();
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);


    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Konfirmasi Penyewaan', style: AppTheme.heading(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kostum: ${widget.costume.name}', style: AppTheme.body(14)),
            const SizedBox(height: 10),
            Text(
                'Tanggal Sewa: ${_dateFormatter.format(_startDate!)} - ${_dateFormatter.format(_endDate!)}',
                style: AppTheme.body(14, color: AppColors.textSecondary)),
            const SizedBox(height: 10),
            Text('Total Hari: $totalDays hari', style: AppTheme.body(14, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Text(
              'Total Harga: ${currencyFormatter.format(totalPrice)}',
              style: AppTheme.heading(18, weight: FontWeight.w700, color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Sewa'),
            onPressed: () async {
              setState(() {
                _isSaving = true;
              });
              Navigator.of(ctx).pop();

              try {
                await _authService.saveRentalHistory(
                  costume: widget.costume,
                  startDate: _startDate!,
                  endDate: _endDate!,
                  totalPrice: totalPrice,
                );

                Provider.of<CostumeProvider>(context, listen: false)
                    .updateAvailability(widget.costume.id, false);

                if (mounted) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SuccessScreen(),
                  ));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
                }
              } finally {
                if (mounted) {
                  setState(() {
                    _isSaving = false;
                  });
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: Text('Sewa ${widget.costume.name}', style: AppTheme.heading(20)),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : StudioBackground(
        showGlow: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Ringkasan item ──
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.costume.name, style: AppTheme.heading(24)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _buildMetaChip(Icons.straighten_rounded, 'Ukuran ${widget.costume.size}', AppColors.accent),
                        const SizedBox(width: 10),
                        _buildMetaChip(Icons.sell_rounded, currencyFormatter.format(widget.costume.price), AppColors.primary),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                        const SizedBox(width: 8),
                        Text('Status: Tersedia',
                            style: AppTheme.body(14, weight: FontWeight.w700, color: AppColors.success)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Pilih Tanggal Sewa', style: AppTheme.heading(20)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDateButton(
                      icon: Icons.calendar_today_rounded,
                      label: _startDate == null ? 'Mulai' : _dateFormatter.format(_startDate!),
                      onPressed: () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateButton(
                      icon: Icons.event_available_rounded,
                      label: _endDate == null ? 'Selesai' : _dateFormatter.format(_endDate!),
                      onPressed: _startDate == null ? null : () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (_calculateRentalDays() > 0)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$_calculateRentalDays() hari sewa',
                            style: AppTheme.body(12, color: AppColors.textSecondary)),
                        const SizedBox(height: 2),
                        Text('Total Harga', style: AppTheme.body(14, weight: FontWeight.w600)),
                      ],
                    ),
                    Text(
                      currencyFormatter.format(_calculateTotalPrice()),
                      style: AppTheme.heading(22, weight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 30),
            GradientButton(
              label: 'Konfirmasi & Sewa',
              icon: Icons.bolt_rounded,
              onPressed: _confirmRental,
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadii.sm),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label, style: AppTheme.body(13, weight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildDateButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 54,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(label, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: BorderSide(
            color: onPressed == null ? AppColors.divider : AppColors.primary.withOpacity(0.4),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle: AppTheme.body(14, weight: FontWeight.w600),
        ),
        onPressed: onPressed,
      ),
    );
  }
}