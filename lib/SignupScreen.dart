import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void navigateToLoginScreen() {
    Navigator.pushNamed(context, '/login');
  }

  void navigateToDemandScreen() {
    Navigator.pushNamed(context, '/demandeu');
  }

  Future<void> signUp() async {
    final Uri uri = Uri.parse("http://localhost:8080/api/auth/signup");

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'role': ['ROLE_USER'], // Set default role here
        }),
      );

      if (response.statusCode == 200) {
        // Successful sign-up, handle the response
        // You might want to navigate to the login screen or perform other actions
        print('User registered successfully!');
        navigateToDemandScreen();
      } else {
        // Handle sign-up failure
        print('Failed to sign up: ${response.body}');
      }
    } catch (error) {
      print('Error signing up: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/logo-dark.png', // Add your own image asset
              height: 150.0,
            ),
            SizedBox(height: 32.0),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Call the signUp function when the button is pressed
                signUp();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32.0),
              ),
            ),
            SizedBox(height: 16.0),
            Text('or', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16.0),
           Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Image.asset(
      'assets/icons/images.jpeg', // Replace with your Facebook icon asset
      height: 40.0,
      width: 40.0,
    ),
    SizedBox(width: 16.0),
    Image.asset(
      'assets/icons/Google_svg.png', // Replace with your Google icon asset
      height: 40.0,
      width: 40.0,
    ),
    SizedBox(width: 16.0),
    Image.asset(
      'assets/icons/Logo_of_Twitter.svg.png', // Replace with your Twitter icon asset
      height: 40.0,
      width: 40.0,
    ),
  ],
),


            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Navigate to the sign-up screen when the button is pressed
                navigateToLoginScreen();
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
