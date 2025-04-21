import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AuthValidator {
  static String? validate(String email, String password) {
    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email)) {
      return "Geçersiz e-posta adresi formatı.";
    }
    if (password.isEmpty) {
      return "Şifre boş olamaz.";
    }
    return null; 
  }
}

class AuthErrorHandler {
  static String getMessage(String code) {
    print(code);

    if (code == 'user-not-found') {
      return "No users registered with this email were found.";
    }
    if (code == 'invalid-credential') {
      return "The email or password you entered is incorrect.";
    }
    if (code == 'too-many-requests') {
      return "Too many attempts have been made. Please try again later.";
    }
    if (code == 'email-already-in-use') {
      return "This email address is already used in another account.";
    } else {
      return "An error has occurred. Please try again.";
    }
  }
}

class MoneyInputFormatter extends TextInputFormatter {
  final _formatter = NumberFormat("#,##0", "tr_TR");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var raw = newValue.text
        .replaceAll(' TL', '')
        .replaceAll('.', '')
        .replaceAll(' ', '');
    final hasComma = raw.contains(',');
    final parts = raw.split(',');

    String whole = parts[0].replaceAll(RegExp(r'[^0-9]'), '');
    String decimal =
        parts.length > 1 ? parts[1].replaceAll(RegExp(r'[^0-9]'), '') : '';

    if (whole.isEmpty) whole = '0';
    if (decimal.length > 2) decimal = decimal.substring(0, 2);

    String formatted =
        hasComma
            ? '${_formatter.format(int.parse(whole))},$decimal'
            : _formatter.format(int.parse(whole));

    formatted = '$formatted TL';
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length - 3),
    );
  }
}

class AmountFormatter {
  static double? parse(String input) {
    final cleaned =
        input
            .replaceAll(' TL', '')
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .trim();

    final valid = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!valid.hasMatch(cleaned)) return null;

    return double.tryParse(cleaned);
  }
}
