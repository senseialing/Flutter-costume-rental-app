import 'package:flutter/material.dart';
import '../models/costume.dart';

class CostumeCard extends StatelessWidget {
  final Costume costume;

  const CostumeCard({required this.costume, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/rental', arguments: costume);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        color: Colors.white.withOpacity(0.3), // Transparan putih 30%
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar kostum
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  costume.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Informasi kostum
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Konten info di-wrap dengan Expanded + SingleChildScrollView
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              costume.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple[900],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              costume.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Ukuran: ${costume.sizes.join(', ')}',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Bahan: ${costume.material}',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Rp ${costume.price.toStringAsFixed(0)} / hari',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/rental', arguments: costume);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          'Sewa',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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
