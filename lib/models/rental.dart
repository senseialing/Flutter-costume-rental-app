import 'package:flutter/material.dart';
import 'costume.dart';

class Rental {
  final Costume costume;
  final DateTime date;
  final int duration;

  Rental({
    required this.costume,
    required this.date,
    required this.duration,
  });
}
