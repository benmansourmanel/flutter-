import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  // Function to check credentials in Firestore
  Future<void> _loginUser() async {
    final login = _loginController.text.trim();
    final password = _passwordController.text.trim();

    if (login.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Login and password cannot be empty';
      });
      return;
    }

    try {
      // Query Firestore for the user with matching login and password
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('login', isEqualTo: login)
          .where('password', isEqualTo: password)
          .get();

      if (userQuery.docs.isNotEmpty) {
        // If user is found, navigate to the WelcomeScreen
        Navigator.pushNamed(context, MyRoutes.welcomeRoute);
      } else {
        // If user is not found, show error message
        setState(() {
          _errorMessage = 'Incorrect login or password';
        });
      }
    } catch (e) {
      print('Error logging in: $e');
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/welcome_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Form Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 36,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "assets/images/app_logo.png",
                        scale: 4.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Login Form
                  TextField(
                    controller: _loginController,
                    decoration: InputDecoration(
                      labelText: "Login",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  // Error Message Display
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Submit Button
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ElevatedButton(
                      onPressed: _loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff23AA49),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text("Login"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
