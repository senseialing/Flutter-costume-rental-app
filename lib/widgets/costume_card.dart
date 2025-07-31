import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penyewaanbaju/models/costume.dart';
import 'package:penyewaanbaju/screens/detail_screen.dart';

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
          // 1. Latar belakang kartu dibuat putih solid
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          // 2. Efek bayangan yang lebih halus dan premium
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // BAGIAN GAMBAR
                Expanded(
                  flex: 3, // Gambar mengambil porsi lebih besar
                  child: Hero(
                    tag: costume.id,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: Image.network(
                        costume.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey));
                        },
                      ),
                    ),
                  ),
                ),
                // BAGIAN TEKS
                Expanded(
                  flex: 2, // Teks mengambil porsi lebih kecil
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Nama Kostum
                        Text(
                          costume.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Rating Bintang
                        if (costume.reviewCount > 0)
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${costume.rating}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                ' (${costume.reviewCount})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        // Harga Sewa
                        Text(
                          currencyFormatter.format(costume.price),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Overlay jika barang tidak tersedia
            if (!costume.isAvailable)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    'Tidak Tersedia',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}