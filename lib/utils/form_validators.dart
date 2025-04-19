import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AuthValidator {
  static String? validate(String email, String password) {
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
      return "Geçersiz e-posta adresi formatı.";
    }
    if (password.isEmpty) {
      return "Şifre boş olamaz.";
    }
    return null; // Her şey geçerli
  }
}

class AuthErrorHandler {
  static String getMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return "Bu e-posta ile kayıtlı bir kullanıcı bulunamadı.";
      case 'wrong-password':
        return "Şifre hatalı. Lütfen tekrar deneyin.";
      case 'invalid-email':
        return "Geçersiz e-posta adresi.";
      case 'user-disabled':
        return "Bu kullanıcı hesabı devre dışı bırakılmış.";
      case 'too-many-requests':
        return "Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin.";
      default:
        return "Bir hata oluştu. Lütfen tekrar deneyin.";
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
