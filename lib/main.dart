import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:penyewaanbaju/providers/costume_provider.dart';
import 'package:penyewaanbaju/screens/home_screen.dart';
import 'package:penyewaanbaju/screens/login_screen.dart';
import 'package:penyewaanbaju/theme/app_theme.dart';
import 'package:penyewaanbaju/utils/preferences_helper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// --- TAMBAHKAN DUA IMPORT INI ---
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- TAMBAHKAN BARIS INI UNTUK MENYIAPKAN FORMAT TANGGAL INDONESIA ---
  await initializeDateFormatting('id_ID', null);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool isLoggedIn = await PreferencesHelper.getLoggedIn();

  runApp(
    ChangeNotifierProvider(
      create: (context) => CostumeProvider(),
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAMCOSPLY',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const HomeScreen() : LoginScreen(),
    );
  }
}