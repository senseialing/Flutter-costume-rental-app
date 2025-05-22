import 'dart:ui'; // <== tambahkan ini untuk BackdropFilter
import 'package:flutter/material.dart';
import '../models/costume.dart';
import '../widgets/costume_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(), // Ganti dengan login dulu
  ));
}
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> categories = ['Baju', 'Aksesoris', 'Wig'];

  final List<Costume> allCostumes = [
    // Baju
    Costume(
      name: 'Naruto',
      imageUrl: 'assets/images/naruto.jpg',
      price: 350000,
      description: 'Jubah Hokage lengkap dengan ikat kepala dan aksesoris khas Naruto.',
      category: 'baju',
      sizes: ['M', 'L', 'XL'],
      material: 'Katun + Polyester',
      careInstructions: 'Cuci kering atau manual, hindari mesin cuci.',
      returnPolicy: 'Dikembalikan maksimal 2 hari setelah masa sewa berakhir.',
    ),
    Costume(
      name: 'Sasuke',
      imageUrl: 'assets/images/sasuke.jpg',
      price: 420000,
      description: 'Pakaian Sasuke dengan pedang dan ikat pinggang klan Uchiha.',
      category: 'baju',
      sizes: ['L', 'XL'],
      material: 'Katun Premium',
      careInstructions: 'Cuci manual dengan air dingin.',
      returnPolicy: 'Pengembalian dalam 1 hari setelah masa sewa.',
    ),
    Costume(
      name: 'Sakura',
      imageUrl: 'assets/images/sakura.jpg',
      price: 390000,
      description: 'Baju ninja medis Sakura lengkap dengan sarung tangan dan sepatu ninja.',
      category: 'baju',
      sizes: ['S', 'M'],
      material: 'Spandex + Katun',
      careInstructions: 'Hanya dry cleaning.',
      returnPolicy: 'Kostum harus dalam kondisi bersih saat dikembalikan.',
    ),

    // Aksesoris
    Costume(
      name: 'Pedang Katana',
      imageUrl: 'assets/images/pedang.jpg',
      price: 150000,
      description: 'Pedang katana asli untuk cosplay karakter samurai.',
      category: 'Aksesoris',
      sizes: ['One Size'],
      material: 'Plastik + Besi Ringan',
      careInstructions: 'Lap dengan kain kering.',
      returnPolicy: 'Harus dikembalikan tanpa kerusakan.',
    ),
    Costume(
      name: 'Shuriken',
      imageUrl: 'assets/images/shuriken.jpg',
      price: 50000,
      description: 'Shuriken ninja yang tajam dan realistis.',
      category: 'Aksesoris',
      sizes: ['One Size'],
      material: 'Logam Aluminium',
      careInstructions: 'Lap dengan tisu kering setelah digunakan.',
      returnPolicy: 'Jika hilang, ganti biaya sebesar Rp 50.000.',
    ),

    // Wig
    Costume(
      name: 'Wig Naruto',
      imageUrl: 'assets/images/wig_naruto.jpg',
      price: 120000,
      description: 'Wig kuning khas Naruto untuk cosplay.',
      category: 'Wig',
      sizes: ['All Size'],
      material: 'Serat sintetis tahan panas',
      careInstructions: 'Disisir dan disimpan dalam kotak.',
      returnPolicy: 'Jangan dicuci, wajib kembalikan dalam kotak.',
    ),
    Costume(
      name: 'Ikat Kepala Ninja',
      imageUrl: 'assets/images/ikat_kepala.jpg',
      price: 60000,
      description: 'Ikat kepala ninja dengan simbol Konoha.',
      category: 'Wig',
      sizes: ['All Size'],
      material: 'Kain + Plat Logam',
      careInstructions: 'Lap bagian logam jika berkarat.',
      returnPolicy: 'Wajib dikembalikan dalam pouch aslinya.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ganti appBar default dengan widget custom:
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 48), // tinggi AppBar + TabBar
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.deepPurple.withOpacity(0.3), // transparan dengan warna dasar
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 48), // spacer kiri (bisa ganti jadi button menu)
                          Text(
                            'Penyewaan Baju Cosplay',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 6.0,
                                  color: Colors.black45,
                                  offset: Offset(1.5, 1.5),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.history, color: Colors.white),
                            onPressed: () {
                              Navigator.pushNamed(context, '/history');
                            },
                          ),
                        ],
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      tabs: categories.map((cat) => Tab(text: cat)).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          TabBarView(
            controller: _tabController,
            children: categories.map((category) {
              final filteredCostumes = allCostumes
                  .where((c) => c.category.toLowerCase() == category.toLowerCase())
                  .toList();

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: filteredCostumes.isEmpty
                    ? Center(
                  child: Text(
                    'Tidak ada kostum di kategori ini',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                  ),
                )
                    : GridView.builder(
                  itemCount: filteredCostumes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (ctx, i) => CostumeCard(costume: filteredCostumes[i]),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
