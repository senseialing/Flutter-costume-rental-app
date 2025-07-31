import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:penyewaanbaju/models/costume.dart';
import 'package:penyewaanbaju/services/api_service.dart';

class CostumeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Costume> _costumes = [];
  bool _isLoading = true;
  String? _error;

  List<Costume> get costumes => _costumes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Ganti alamat IP ini jika IP komputer Anda berubah
  final String _baseUrl = 'http://localhost:3000';

  CostumeProvider() {
    fetchCostumes();
  }

  // Mengambil daftar kostum dari server
  Future<void> fetchCostumes() async {
    _isLoading = true;
    _error = null;
    // Hindari notifyListeners() di awal agar tidak ada build ganda

    try {
      _costumes = await _apiService.getCostumes();
    } catch (e) {
      _error = e.toString();
      print('Error fetching costumes: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Menambah kostum baru ke db.json
  Future<void> addCostume(Costume costume) async {
    final newCostumeData = {
      // json-server akan membuat ID jika tidak disediakan, tapi kita buat sendiri untuk konsistensi
      'id': 'c${DateTime.now().millisecondsSinceEpoch}',
      'name': costume.name,
      'imageUrl': costume.imageUrl,
      'description': costume.description,
      'size': costume.size,
      'price': costume.price,
      'rating': 0.0,
      'reviewCount': 0,
      'isAvailable': true,
      'category': costume.category,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/baju'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newCostumeData),
    );

    if (response.statusCode == 201) { // 201 Created
      // Jika berhasil, tambahkan langsung ke list lokal & notify
      _costumes.add(Costume.fromJson(newCostumeData));
      notifyListeners();
    } else {
      throw Exception('Gagal menambah kostum ke db.json');
    }
  }

  // Mengedit kostum yang ada di db.json
  Future<void> updateCostume(Costume costume) async {
    final updatedCostumeData = {
      'id': costume.id,
      'name': costume.name,
      'imageUrl': costume.imageUrl,
      'description': costume.description,
      'size': costume.size,
      'price': costume.price,
      'rating': costume.rating,
      'reviewCount': costume.reviewCount,
      'isAvailable': costume.isAvailable,
      'category': costume.category,
    };

    final response = await http.put(
      Uri.parse('$_baseUrl/baju/${costume.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedCostumeData),
    );

    if (response.statusCode == 200) { // 200 OK
      // Update data di list lokal
      final index = _costumes.indexWhere((c) => c.id == costume.id);
      if (index != -1) {
        _costumes[index] = costume;
        notifyListeners();
      }
    } else {
      throw Exception('Gagal mengedit kostum di db.json');
    }
  }

  // Menghapus kostum dari db.json
  Future<void> deleteCostume(String costumeId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/baju/$costumeId'));

    if (response.statusCode == 200) {
      // Hapus dari list lokal
      _costumes.removeWhere((c) => c.id == costumeId);
      notifyListeners();
    } else {
      throw Exception('Gagal menghapus kostum dari db.json');
    }
  }

  // Mengubah status ketersediaan (simulasi di memori aplikasi)
  void updateAvailability(String costumeId, bool isAvailable) {
    final index = _costumes.indexWhere((c) => c.id == costumeId);
    if (index != -1) {
      _costumes[index].isAvailable = isAvailable;
      notifyListeners();
    }
  }
}