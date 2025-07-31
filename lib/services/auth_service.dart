import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:penyewaanbaju/utils/preferences_helper.dart';
import 'package:penyewaanbaju/models/costume.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream untuk memantau status login pengguna
  Stream<User?> get user => _auth.authStateChanges();

  // Fungsi untuk registrasi pengguna baru
  Future<User?> registerWithEmailPassword(
      String email,
      String password,
      String nama,
      String alamat,
      String telepon,
      ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Menyimpan data tambahan pengguna ke Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'nama': nama,
          'email': email,
          'alamat': alamat,
          'telepon': telepon,
          'createdAt': Timestamp.now(),
          'isAdmin': false, // Default user bukan admin
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print('Error registrasi: ${e.message}');
      return null;
    }
  }

  // Fungsi untuk login pengguna
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        // Menyimpan status login secara lokal
        await PreferencesHelper.setLoggedIn(true);
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Error login: ${e.message}');
      return null;
    }
  }

  // Fungsi untuk logout
  Future<void> signOut() async {
    await _auth.signOut();
    await PreferencesHelper.setLoggedIn(false);
  }

  // Mengambil data profil pengguna secara real-time
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection('users').doc(user.uid).snapshots();
    } else {
      return Stream.empty();
    }
  }

  // Memeriksa apakah pengguna saat ini adalah admin
  Future<bool> checkIsAdmin() async {
    final user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data()?['isAdmin'] ?? false;
    } catch (e) {
      return false;
    }
  }

  // Memperbarui data profil pengguna
  Future<void> updateUserProfile(String newName, String newAlamat, String newTelepon) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'nama': newName,
          'alamat': newAlamat,
          'telepon': newTelepon,
        });
      } catch (e) {
        print('Gagal memperbarui profil: $e');
        rethrow;
      }
    }
  }

  // Menyimpan riwayat sewa ke Firestore
  Future<void> saveRentalHistory({
    required Costume costume,
    required DateTime startDate,
    required DateTime endDate,
    required int totalPrice,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Mengambil nama pengguna dari profil untuk disimpan di riwayat
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userName = userDoc.data()?['nama'] ?? 'Pengguna';

      await _firestore.collection('rentals').add({
        'userId': user.uid,
        'userName': userName, // Simpan nama penyewa
        'costumeId': costume.id,
        'costumeName': costume.name,
        'imageUrl': costume.imageUrl,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'totalPrice': totalPrice,
        'rentalDate': Timestamp.now(),
        'status': 'Menunggu Konfirmasi',
      });
    } catch (e) {
      print('Gagal menyimpan riwayat sewa: $e');
      rethrow;
    }
  }

  // Mengambil riwayat sewa untuk pengguna yang login
  Stream<QuerySnapshot<Map<String, dynamic>>> getRentalHistoryStream() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('rentals')
          .where('userId', isEqualTo: user.uid)
          .orderBy('rentalDate', descending: true)
          .snapshots();
    } else {
      return Stream.empty();
    }
  }

  // --- FUNGSI KHUSUS ADMIN ---

  // Mengambil semua permintaan sewa untuk admin
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRentalRequests() {
    return _firestore
        .collection('rentals')
        .orderBy('rentalDate', descending: true)
        .snapshots();
  }

  // Memperbarui status sewa (oleh admin)
  Future<void> updateRentalStatus(String rentalId, String newStatus) {
    return _firestore.collection('rentals').doc(rentalId).update({
      'status': newStatus,
    });
  }
}