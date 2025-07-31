import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:penyewaanbaju/models/costume.dart';

class ApiService {
  // PASTIKAN IP ADDRESS DI SINI SUDAH BENAR
  Future<List<Costume>> getCostumes() async {
    const String baseUrl = 'http://localhost:3000'; // <-- Ganti jika perlu
    final response = await http.get(Uri.parse('$baseUrl/baju'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Costume.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data kostum dari server');
    }
  }
}