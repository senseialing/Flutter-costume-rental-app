import 'package:flutter/material.dart';
import '../models/costume.dart';
import '../widgets/costume_card.dart';
import 'package:google_fonts/google_fonts.dart';

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
    ),
    Costume(
      name: 'Sasuke',
      imageUrl: 'assets/images/sasuke.jpg',
      price: 420000,
      description: 'Pakaian Sasuke dengan pedang dan ikat pinggang klan Uchiha.',
      category: 'baju',
    ),
    Costume(
      name: 'Sakura',
      imageUrl: 'assets/images/sakura.jpg',
      price: 390000,
      description: 'Baju ninja medis Sakura lengkap dengan sarung tangan dan sepatu ninja.',
      category: 'baju',
    ),

    // Aksesoris
    Costume(
      name: 'Pedang Katana',
      imageUrl: 'assets/images/pedang.jpg',
      price: 150000,
      description: 'Pedang katana asli untuk cosplay karakter samurai.',
      category: 'Aksesoris',
    ),
    Costume(
      name: 'Shuriken',
      imageUrl: 'assets/images/shuriken.jpg',
      price: 50000,
      description: 'Shuriken ninja yang tajam dan realistis.',
      category: 'Aksesoris',
    ),

    // wig
    Costume(
      name: 'Wig Naruto',
      imageUrl: 'assets/images/wig_naruto.jpg',
      price: 120000,
      description: 'Wig kuning khas Naruto untuk cosplay.',
      category: 'Wig',
    ),
    Costume(
      name: 'Ikat Kepala Ninja',
      imageUrl: 'assets/images/ikat_kepala.jpg',
      price: 60000,
      description: 'Ikat kepala ninja dengan simbol Konoha.',
      category: 'Wig',
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
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(
          'Penyewaan Baju Cosplay',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: categories.map((cat) => Tab(text: cat)).toList(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay supaya konten tetap terlihat jelas
          Container(color: Colors.black.withOpacity(0.3)),
          // Konten utama dengan TabBarView
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
