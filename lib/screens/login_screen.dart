import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:myapp/screens/expense_list.dart';
import 'package:myapp/screens/forgot_password.dart';
import 'package:myapp/screens/register_screen.dart';
import 'package:myapp/services/firebase_auth.dart';
import 'package:myapp/utils/form_validators.dart';
import 'package:myapp/utils/string_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuthService _auth = FirebaseAuthService();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearError);
    _passwordController.addListener(_clearError);
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
  }

  void _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final validationError = AuthValidator.validate(email, password);
    if (validationError != null) {
      setState(() => _errorMessage = validationError);
      return;
    }

    try {
      final user = await _auth.signInWithEmailAndPassword(email, password);
      if (!mounted) return;
      if (user is User) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const ExpenseListScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  clipoval(),
                  Text(
                    StringUtils.appName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreenAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 45),
              const Text(
                StringUtils.header,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                StringUtils.description,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Center(child: _loginCard()),
            ],
          ),
        ),
      ),
    );
  }

  Card _loginCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "LOGIN",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                _emailController,
                "Email",
                Icons.email,
                false,
                TextInputType.emailAddress,
                TextInputAction.next,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _passwordController,
                "Password",
                Icons.lock,
                true,
                TextInputType.text,
                TextInputAction.done,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("LOGIN"),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 12),
              _Txtbutton(screen: RegisterScreen(), txt: StringUtils.register),
              _Txtbutton(
                screen: ForgotPasswordScreen(),
                txt: StringUtils.forgot,
                txtColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ClipOval clipoval() {
    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Image.asset(
          'assets/icon/icon.png',
          height: 48,
          width: 48,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _Txtbutton extends StatelessWidget {
  final Widget screen;
  final Color? txtColor;
  final String txt;
  const _Txtbutton({required this.screen, required this.txt, this.txtColor});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Text(
        txt,
        style: TextStyle(color: txtColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

Widget _buildTextField(
  TextEditingController controller,
  String label,
  IconData icon,
  bool obscure,
  TextInputType keyboardType,
  TextInputAction textInputAction,
) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon),
    ),
  );
}
