import 'package:flutter/material.dart';

SnackBar errorSnackBar(String message) {
  return SnackBar(
    content: Text(message),
    backgroundColor: const Color.fromRGBO(220, 76, 100, 0.6),
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0, // Inner padding for SnackBar content.
      vertical: 10,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}

SnackBar successSnackBar(String message) {
  return SnackBar(
    content: Text(message),
    backgroundColor: const Color.fromRGBO(20, 164, 77, 0.6),
    padding: const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 10.0, // inner padding for SnackBar content.
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
