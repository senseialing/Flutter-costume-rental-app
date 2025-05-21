import 'package:flutter/material.dart';
import '../models/costume.dart';

class DetailScreen extends StatelessWidget {
  final Costume costume;

  const DetailScreen({super.key, required this.costume});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(costume.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              costume.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              costume.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Ukuran: ${costume.size}'),
            Text('Rp ${costume.price.toStringAsFixed(0)} / hari'),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                costume.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/rental', arguments: costume);
              },
              child: const Text('Sewa Sekarang'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
