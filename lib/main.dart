import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/rental_screen.dart';
import 'screens/rental_history_screen.dart';
import 'screens/login_screen.dart'; // <== Tambahkan ini
import 'models/costume.dart';
import 'providers/rental_history.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RentalHistory(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Penyewaan Baju Cosplay',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: LoginScreen(), // <== Ubah jadi LoginScreen
        routes: {
          '/home': (ctx) => HomeScreen(), // opsional kalau ingin pakai named
          '/rental': (ctx) => RentalScreen(),
          '/history': (ctx) => RentalHistoryScreen(),
        },
      ),
    );
  }
}
