import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/services/firebase_auth.dart';
import 'package:myapp/utils/form_validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();

  String? _errorMessage;

  void _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final validationError = AuthValidator.validate(email, password);
    if (validationError != null) {
      setState(() => _errorMessage = validationError);
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = "Passwords do not match.";
      });
      return;
    }
    try {
      User? user = await _authService.registerWithEmailAndPassword(
        email,
        password,
      );
      if (user != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "REGISTER",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                RegisterEmail(emailController: _emailController),
                SizedBox(height: 16),
                RegisterPswrd(passwordController: _passwordController),
                SizedBox(height: 16),
                RegisterConfirmPswrd(confirmPasswordController: _confirmPasswordController),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    _register();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: Text("REGİSTER"),
                ),
                if (_errorMessage != null) ...[
                  SizedBox(height: 16),
                  Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                ],
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Already have an account? Login here"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterConfirmPswrd extends StatelessWidget {
  const RegisterConfirmPswrd({
    super.key,
    required TextEditingController confirmPasswordController,
  }) : _confirmPasswordController = confirmPasswordController;

  final TextEditingController _confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Confirm Password",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock_outline),
      ),
    );
  }
}

class RegisterPswrd extends StatelessWidget {
  const RegisterPswrd({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
    );
  }
}

class RegisterEmail extends StatelessWidget {
  const RegisterEmail({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
    );
  }
}
