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
