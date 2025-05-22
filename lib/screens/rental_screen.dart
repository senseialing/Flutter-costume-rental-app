import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/costume.dart';
import '../models/rental.dart';
import 'package:provider/provider.dart';
import '../providers/rental_history.dart';

class RentalScreen extends StatefulWidget {
  @override
  _RentalScreenState createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> {
  int duration = 1;
  DateTime? startDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Costume costume = ModalRoute.of(context)!.settings.arguments as Costume;
    int totalPrice = costume.price * duration;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg_rental.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sewa Kostum',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      costume.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    costume.name,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    costume.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.white24),
                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ukuran Tersedia: ${costume.sizes.join(', ')}',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'Bahan: ${costume.material}',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'Perawatan: ${costume.careInstructions}',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'Kebijakan Pengembalian: ${costume.returnPolicy}',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          costume.isAvailable ? 'Status: Tersedia' : 'Status: Tidak Tersedia',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: costume.isAvailable ? Colors.greenAccent : Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Durasi Sewa (hari)',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<int>(
                    value: duration,
                    dropdownColor: Colors.deepPurple[200],
                    iconEnabledColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    onChanged: (int? newValue) {
                      setState(() {
                        duration = newValue!;
                      });
                    },
                    items: List.generate(
                      10,
                          (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1} hari'),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Pilih Tanggal Mulai Sewa',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white70),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            startDate != null
                                ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                                : 'Pilih tanggal',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                          Icon(Icons.calendar_today, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                  if (startDate != null) ...[
                    SizedBox(height: 10),
                    Text(
                      'Tanggal Selesai: ${startDate!.add(Duration(days: duration)).day}/${startDate!.add(Duration(days: duration)).month}/${startDate!.add(Duration(days: duration)).year}',
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),
                  ],

                  SizedBox(height: 20),
                  Text(
                    'Total Harga: Rp $totalPrice',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: costume.isAvailable
                        ? () {
                      if (startDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Silakan pilih tanggal mulai sewa')),
                        );
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Konfirmasi Sewa'),
                          content: Text(
                            'Anda akan menyewa ${costume.name} dari '
                                '${startDate!.day}/${startDate!.month}/${startDate!.year} '
                                'selama $duration hari.\nTotal harga: Rp $totalPrice.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Provider.of<RentalHistory>(context, listen: false).addRental(
                                  Rental(
                                    costume: costume,
                                    date: startDate!,
                                    duration: duration,
                                  ),
                                );
                                setState(() {
                                  costume.isAvailable = false;
                                });
                                Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Berhasil menyewa ${costume.name}')),
                                );
                                Navigator.pop(context);
                              },
                              child: Text('Konfirmasi'),
                            ),
                          ],
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: costume.isAvailable ? Colors.white : Colors.grey,
                      foregroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Sewa Sekarang',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
