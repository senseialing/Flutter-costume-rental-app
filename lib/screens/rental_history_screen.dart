import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rental.dart';
import '../providers/rental_history.dart';
import 'package:intl/intl.dart';

class RentalHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rentalHistory = Provider.of<RentalHistory>(context);
    final rentals = rentalHistory.rentals;

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Penyewaan'),
      ),
      body: rentals.isEmpty
          ? Center(child: Text('Belum ada riwayat penyewaan'))
          : ListView.builder(
        itemCount: rentals.length,
        itemBuilder: (ctx, i) {
          final rental = rentals[i];
          final totalPrice = rental.costume.price * rental.duration;
          final formattedDate = DateFormat('dd-MM-yyyy').format(rental.date);

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: Image.asset(
                rental.costume.imageUrl,
                width: 60,
                fit: BoxFit.cover,
              ),
              title: Text(rental.costume.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tanggal Sewa: $formattedDate'),
                  Text('Durasi: ${rental.duration} hari'),
                  Text('Total Harga: Rp ${totalPrice.toString()}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
