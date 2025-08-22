import 'package:flutter/material.dart';

Color getBackgroundColor(double temp) {
  if (temp <= 15) {
    return Colors.blue.shade200; // Cool color
  } else if (temp > 15 && temp <= 25) {
    return Colors.green.shade200; // Mild/Warm
  } else if (temp > 25 && temp <= 35) {
    return Colors.indigo.shade200; // Average hot
  } else {
    return Colors.red.shade300; // Very hot
  }
}
