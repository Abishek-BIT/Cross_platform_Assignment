import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'home_screen.dart'; // Home Screen

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Method to authenticate (Log in or Sign up)
  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) {
      return; // If form is invalid, do not proceed
    }
    
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    ParseResponse response;
    if (_isLogin) {
      // Log in
      response = await ParseUser(username, password, null).login();
    } else {
      // Sign up
      final user = ParseUser(username, password, null);
      response = await user.signUp(allowWithoutEmail: true); // Allow sign-up without email
    }

    if (response.success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => HomeScreen()), // Navigate to HomeScreen
      );
    } else {
      _showMessage(response.error?.message ?? 'An error occurred');
    }
  }

  // Method to show messages as SnackBar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Log In' : 'Sign Up'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Text
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  _isLogin ? 'Welcome Back!' : 'Create an Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Login/Signup Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Username TextField
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    
                    // Password TextField
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    
                    // Submit Button
                    ElevatedButton(
                      onPressed: _authenticate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,  // Use backgroundColor instead of primary
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _isLogin ? 'Log In' : 'Sign Up',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Switch between Login and Signup
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(
                  _isLogin
                      ? 'Don\'t have an account? Sign Up'
                      : 'Already have an account? Log In',
                  style: TextStyle(color: Colors.teal, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
