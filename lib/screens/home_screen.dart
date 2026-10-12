import 'dart:async';
import 'package:flutter/material.dart';
import 'package:penyewaanbaju/models/costume.dart';
import 'package:penyewaanbaju/providers/costume_provider.dart';
import 'package:penyewaanbaju/widgets/costume_card.dart';
import 'package:penyewaanbaju/screens/login_screen.dart';
import 'package:penyewaanbaju/services/auth_service.dart';
import 'package:penyewaanbaju/screens/profile_screen.dart';
import 'package:penyewaanbaju/screens/history_screen.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/widgets/common.dart';
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
      backgroundColor: AppColors.scaffoldDark,
      extendBody: true, // Membuat body bisa berada di belakang navbar
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'RAMCOSPLY',
              style: AppTheme.display(26, letterSpacing: 2),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldDark.withOpacity(0.85),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.divider, width: 1),
            ),
          ),
        ),
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

          return StudioBackground(
            child: pageOptions.elementAt(_selectedIndex),
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

          return Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark.withOpacity(0.95),
              border: Border(
                top: BorderSide(color: AppColors.divider, width: 1),
              ),
            ),
            child: BottomNavigationBar(
              items: navBarItems,
              currentIndex: _selectedIndex,
              backgroundColor: Colors.transparent,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textMuted,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: AppTheme.body(11, weight: FontWeight.w700),
              unselectedLabelStyle: AppTheme.body(11),
              onTap: _onItemTapped,
            ),
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
            final categories = ['Semua', 'Baju', 'Aksesoris'];
            return AlertDialog(
              title: Text('Filter Koleksi', style: AppTheme.heading(20)),
              contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kategori', style: AppTheme.body(12, color: AppColors.textMuted)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((cat) {
                      final selected = tempCategory == cat;
                      return GestureDetector(
                        onTap: () => setDialogState(() => tempCategory = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary.withOpacity(0.16) : AppColors.bgElevated,
                            borderRadius: BorderRadius.circular(AppRadii.sm),
                            border: Border.all(
                              color: selected ? AppColors.primary : AppColors.dividerLight,
                            ),
                          ),
                          child: Text(
                            cat,
                            style: AppTheme.body(13, weight: FontWeight.w600,
                                color: selected ? AppColors.primary : AppColors.textSecondary),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  InkWell(
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                    onTap: () => setDialogState(() => tempTersedia = !tempTersedia),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Checkbox(
                            value: tempTersedia,
                            onChanged: (v) => setDialogState(() => tempTersedia = v ?? false),
                          ),
                          const SizedBox(width: 8),
                          Text('Hanya yang tersedia', style: AppTheme.body(14)),
                        ],
                      ),
                    ),
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
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (provider.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat data.',
                    textAlign: TextAlign.center,
                    style: AppTheme.heading(18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pastikan server berjalan dan koneksi stabil.',
                    textAlign: TextAlign.center,
                    style: AppTheme.body(13, color: AppColors.textMuted),
                  ),
                ],
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
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Search bar ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.bgElevated,
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          border: Border.all(color: AppColors.dividerLight),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: AppTheme.body(14),
                          cursorColor: AppColors.primary,
                          decoration: InputDecoration(
                            hintText: 'Cari kostum anime...',
                            hintStyle: AppTheme.body(14, color: AppColors.textMuted),
                            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Tombol filter berbentuk kotak aksen
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
                        onPressed: _showFilterDialog,
                        tooltip: 'Filter',
                      ),
                    ),
                  ],
                ),
              ),
              // ── Banner carousel + indikator ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: SizedBox(
                  height: 165,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _bannerImages.length,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadii.lg),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(_bannerImages[index], fit: BoxFit.cover),
                            // Gradien bawah agar badge/teks terbaca
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.35),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onPageChanged: (int page) => setState(() { _bannerCurrentPage = page; }),
                  ),
                ),
              ),
              // Indikator banner
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_bannerImages.length, (i) {
                  final active = i == _bannerCurrentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                    width: active ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.dividerLight,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
              const SectionHeader(
                title: 'Koleksi Kostum',
                subtitle: 'Pilih karakter favoritmu',
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
      return const EmptyState(
        icon: Icons.search_off_rounded,
        title: 'Tidak ada kostum',
        message: 'Coba ubah kata kunci pencarian atau filter kategori kamu.',
      );
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