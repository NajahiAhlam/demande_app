import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void navigateToSignUpScreen() {
    Navigator.pushNamed(context, '/signup');
  }

  void navigateToDemandScreenu() {
    Navigator.pushNamed(context, '/demandeu');
  }

  void navigateToDemandScreena() {
    Navigator.pushNamed(context, '/demandea');
  }

  Future<void> saveUsernameToStorage(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  Future<void> login() async {
    final Uri uri = Uri.parse("http://localhost:8080/api/auth/signin");

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final userResponse = await http.get(Uri.parse(
            "http://localhost:8080/api/auth/users/username/${usernameController.text}"));

        if (userResponse.statusCode == 200) {
          dynamic userData = json.decode(userResponse.body);
          String role = userData['roles'][0]['name']; // Assuming roles is an array

          if (role == 'ROLE_ADMIN') {
            print('Admin LOGINED successfully!');
            navigateToDemandScreena();
            saveUsernameToStorage(usernameController.text);
          } else {
            print('User LOGINED successfully!');
            saveUsernameToStorage(usernameController.text);
            navigateToDemandScreenu();
          }
        } else {
          print('Failed to retrieve user details: ${userResponse.body}');
        }
      } else {
        print('Failed to log in: ${response.body}');
      }
    } catch (error) {
      print('Error logging in: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                login();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Login',
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
                  'assets/icons/images.jpeg',
                  height: 40.0,
                  width: 40.0,
                ),
                SizedBox(width: 16.0),
                Image.asset(
                  'assets/icons/Google_svg.png',
                  height: 40.0,
                  width: 40.0,
                ),
                SizedBox(width: 16.0),
                Image.asset(
                  'assets/icons/Logo_of_Twitter.svg.png',
                  height: 40.0,
                  width: 40.0,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                navigateToSignUpScreen();
              },
              child: Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(color: Colors.indigo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
