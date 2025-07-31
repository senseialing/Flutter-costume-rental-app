import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penyewaanbaju/models/costume.dart';
import 'package:penyewaanbaju/providers/costume_provider.dart';
import 'package:penyewaanbaju/services/auth_service.dart';
import 'package:penyewaanbaju/screens/success_screen.dart';
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
        title: const Text('Konfirmasi Penyewaan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kostum: ${widget.costume.name}'),
            const SizedBox(height: 8),
            Text(
                'Tanggal Sewa: ${_dateFormatter.format(_startDate!)} - ${_dateFormatter.format(_endDate!)}'),
            const SizedBox(height: 8),
            Text('Total Hari: $totalDays hari'),
            const SizedBox(height: 16),
            Text(
              'Total Harga: ${currencyFormatter.format(totalPrice)}',
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
      appBar: AppBar(
        title: Text('Sewa ${widget.costume.name}'),
        backgroundColor: Colors.indigo,
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.costume.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Ukuran: ${widget.costume.size}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Harga per hari: ${currencyFormatter.format(widget.costume.price)}',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.deepPurple),
                    ),
                    const Divider(height: 30),
                    const Text(
                      'Status: Tersedia',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Tanggal Sewa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_startDate == null
                        ? 'Mulai'
                        : _dateFormatter.format(_startDate!)),
                    onPressed: () => _selectDate(context, true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_endDate == null
                        ? 'Selesai'
                        : _dateFormatter.format(_endDate!)),
                    onPressed: _startDate == null
                        ? null
                        : () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_calculateRentalDays() > 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Harga:',
                          style: TextStyle(fontSize: 18)),
                      Text(
                        currencyFormatter.format(_calculateTotalPrice()),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: _confirmRental,
                child: const Text('Konfirmasi & Sewa'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}