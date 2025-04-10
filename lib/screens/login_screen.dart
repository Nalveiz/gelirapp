import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/add_expense.dart';
import 'package:myapp/screens/expense_list.dart';
import 'package:myapp/services/firebase_auth.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final FirebaseAuthService _auth = FirebaseAuthService();

  String? _errormessage;

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email)) {
      setState(() {
        _errormessage = "Geçersiz e-posta adresi formatı.";
      });
      return;
    }

    try {
      // Firebase'den kullanıcıyı doğrulama
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        // Giriş başarılıysa, anasayfaya yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ExpenseListScreen()),
        );
      } else {
        setState(() {
          _errormessage = "Giriş başarısız. Lütfen tekrar deneyin.";
        });
      }
    } on FirebaseAuthException catch (e) {
      // Hata mesajı FirebaseAuthException üzerinden alınabilir
      setState(() {
        // Hata türüne göre mesajı belirle
        if (e.code == 'user-not-found') {
          _errormessage = "Bu e-posta ile kayıtlı bir kullanıcı bulunamadı.";
        } else if (e.code == 'wrong-password') {
          _errormessage = "Şifre hatalı. Lütfen tekrar deneyin.";
        } else if (e.code == 'invalid-email') {
          _errormessage = "Geçersiz e-posta adresi.";
        } else {
          _errormessage = "Bir hata oluştu. Lütfen tekrar deneyin.";
        }
      });
    } catch (e) {
      // Diğer hataları yakalamak için genel hata yönetimi
      setState(() {
        _errormessage = "Bir hata oluştu. Lütfen tekrar deneyin.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Giriş Yap",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "E-posta",
                    border: OutlineInputBorder(),

                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    _signIn();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: Text("Giriş Yap"),
                ),
                if (_errormessage != null) ...[
                  SizedBox(height: 16),
                  Text(_errormessage!, style: TextStyle(color: Colors.red)),
                ],
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterScreen()),
                    );
                  },
                  child: Text("Hesabın yok mu? Kayıt ol"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
