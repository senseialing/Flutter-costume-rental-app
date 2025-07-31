import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penyewaanbaju/models/costume.dart';
import 'package:penyewaanbaju/providers/costume_provider.dart';
import 'package:penyewaanbaju/widgets/costume_card.dart';
import 'package:penyewaanbaju/screens/login_screen.dart';
import 'package:penyewaanbaju/services/auth_service.dart';
import 'package:penyewaanbaju/screens/profile_screen.dart';
import 'package:penyewaanbaju/screens/history_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();

  void _logout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Latar belakang utama dipindahkan ke Scaffold utama
      backgroundColor: Colors.transparent,
      extendBody: true, // Membuat body bisa berada di belakang navbar
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/header.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text('RAMCOSPLY', style: GoogleFonts.bebasNeue(fontSize: 32, color: Colors.white, letterSpacing: 2, shadows: [const Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(2, 2))])),
        centerTitle: true,
        actions: const [],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // 2. Body sekarang dibangun oleh FutureBuilder
      body: FutureBuilder<bool>(
        future: _authService.checkIsAdmin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Gagal memverifikasi pengguna."));
          }

          final bool isAdmin = snapshot.data!;
          final List<Widget> pageOptions = isAdmin
              ? [ _HomeContent(key: const ValueKey('home')), ProfileScreen(onLogout: _logout) ]
              : [ _HomeContent(key: const ValueKey('home')), const HistoryScreen(), ProfileScreen(onLogout: _logout) ];

          return Stack(
            children: [
              // Latar belakang diletakkan di sini agar berada di bawah konten
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              pageOptions.elementAt(_selectedIndex),
            ],
          );
        },
      ),
      // 3. BottomNavigationBar juga dibangun oleh FutureBuilder
      bottomNavigationBar: FutureBuilder<bool>(
        future: _authService.checkIsAdmin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink(); // Jangan tampilkan apa-apa saat loading
          }
          final bool isAdmin = snapshot.data!;
          final List<BottomNavigationBarItem> navBarItems = isAdmin
              ? const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ]
              : const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History Sewa'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ];

          if (_selectedIndex >= navBarItems.length) {
            _selectedIndex = 0;
          }

          return BottomNavigationBar(
            items: navBarItems,
            currentIndex: _selectedIndex,
            // --- PERUBAHAN UTAMA UNTUK TAMPILAN NAVBAR ---
            backgroundColor: Colors.black.withOpacity(0.5), // Latar belakang semi-transparan
            selectedItemColor: Colors.white,                 // Warna ikon aktif
            unselectedItemColor: Colors.white70,               // Warna ikon non-aktif
            elevation: 0,                                    // Menghilangkan bayangan
            onTap: _onItemTapped,
          );
        },
      ),
    );
  }
}


// Class _HomeContent dan semua isinya TIDAK ADA PERUBAHAN
class _HomeContent extends StatefulWidget {
  const _HomeContent({super.key});
  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final PageController _pageController = PageController();
  int _bannerCurrentPage = 0;
  late Timer _bannerTimer;
  final List<String> _bannerImages = [
    'assets/banners/1.jpg', 'assets/banners/2.jpg', 'assets/banners/3.jpg',
  ];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _filterTersedia = false;
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!mounted) { timer.cancel(); return; }
      _bannerCurrentPage = (_bannerCurrentPage + 1) % _bannerImages.length;
      if (_pageController.hasClients) {
        _pageController.animateToPage(_bannerCurrentPage, duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bannerTimer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempCategory = _selectedCategory;
        bool tempTersedia = _filterTersedia;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Opsi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
                  RadioListTile<String>(
                    title: const Text('Semua'),
                    value: 'Semua',
                    groupValue: tempCategory,
                    onChanged: (value) => setDialogState(() => tempCategory = value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Baju'),
                    value: 'Baju',
                    groupValue: tempCategory,
                    onChanged: (value) => setDialogState(() => tempCategory = value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Aksesoris'),
                    value: 'Aksesoris',
                    groupValue: tempCategory,
                    onChanged: (value) => setDialogState(() => tempCategory = value!),
                  ),
                  const Divider(),
                  CheckboxListTile(
                    title: const Text('Hanya tampilkan yang tersedia'),
                    value: tempTersedia,
                    onChanged: (bool? value) => setDialogState(() => tempTersedia = value ?? false),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = tempCategory;
                      _filterTersedia = tempTersedia;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Terapkan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CostumeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (provider.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Gagal memuat data. Pastikan JSON Server berjalan dan IP Address sudah benar.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.yellowAccent),
              ),
            ),
          );
        }

        List<Costume> filteredList = provider.costumes;
        if (_filterTersedia) {
          filteredList = filteredList.where((item) => item.isAvailable).toList();
        }
        if (_selectedCategory != 'Semua') {
          filteredList = filteredList.where((item) => item.category == _selectedCategory).toList();
        }
        if (_searchQuery.isNotEmpty) {
          filteredList = filteredList.where((item) => item.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari kostum...',
                          prefixIcon: const Icon(Icons.search, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.3),
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: _showFilterDialog,
                      tooltip: 'Filter',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _bannerImages.length,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(_bannerImages[index], fit: BoxFit.cover),
                      ),
                    ),
                    onPageChanged: (int page) => setState(() { _bannerCurrentPage = page; }),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Pilihan Kostum',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              _buildCostumeGrid(filteredList),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCostumeGrid(List<Costume> items) {
    if (items.isEmpty) {
      return const Center(child: Text('Tidak ada item yang ditemukan.', style: TextStyle(color: Colors.white)));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.65),
      itemCount: items.length,
      itemBuilder: (ctx, i) => CostumeCard(costume: items[i]),
    );
  }
}