import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Ensure the number starts with 06 or 07
    if (newText.length >= 2 && !(newText.startsWith('06') || newText.startsWith('07'))) {
      return oldValue; // Reject invalid start
    }

    // Allow only exactly 10 digits
    if (newText.length > 10) {
      return oldValue;
    }

    return newValue;
  }
}
