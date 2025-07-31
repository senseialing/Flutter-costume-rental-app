import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penyewaanbaju/models/costume.dart';
import 'package:penyewaanbaju/screens/rental_screen.dart';

class DetailScreen extends StatelessWidget {
  final Costume costume;

  const DetailScreen({super.key, required this.costume});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(costume.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: costume.id,
                  child: Image.network(
                    costume.imageUrl,
                    height: MediaQuery.of(context).size.height * 0.5,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.broken_image, size: 50)),
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(costume.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 10),
                      Text('${currencyFormatter.format(costume.price)} / hari',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.cyanAccent)),
                      const SizedBox(height: 10),
                      Text('Ukuran: ${costume.size}', style: const TextStyle(fontSize: 18, color: Colors.white)),
                      const SizedBox(height: 20),
                      const Text('Deskripsi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(costume.description, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.white)),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                          backgroundColor: costume.isAvailable ? Colors.indigo : Colors.grey,
                        ),
                        onPressed: costume.isAvailable
                            ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => RentalScreen(costume: costume),
                            ),
                          );
                        }
                            : null,
                        child: Text(costume.isAvailable ? 'Sewa Sekarang' : 'Tidak Tersedia'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}