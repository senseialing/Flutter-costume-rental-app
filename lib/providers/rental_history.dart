import 'package:flutter/material.dart';
import '../models/rental.dart';

class RentalHistory with ChangeNotifier {
  final List<Rental> _rentals = [];

  List<Rental> get rentals => _rentals;

  void addRental(Rental rental) {
    _rentals.add(rental);
    notifyListeners();
  }
}
