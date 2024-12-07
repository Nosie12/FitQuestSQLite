import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show a dialog if email or password is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter both email and password.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      // Perform Firebase authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Navigate to HomeScreen after successful sign-in
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // Handle Firebase errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.message ?? 'An error occurred'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.05; // 5% padding from the sides

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              children: [
                const SizedBox(height: 80),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Alegreya Sans',
                    color: Color(0xFF467115),
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 1.0,
                        color: Color.fromARGB(128, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 190),

                // Email Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: padding),
                    child: const Text(
                      'Email',
                      style: TextStyle(
                        fontFamily: 'Alegreya',
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // Email Box
                SizedBox(
                  width: screenWidth - 2 * padding,
                  height: 40,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 35),

                // Password Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: padding),
                    child: const Text(
                      'Password',
                      style: TextStyle(
                        fontFamily: 'Alegreya',
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // Password Box
                SizedBox(
                  width: screenWidth - 2 * padding,
                  height: 40,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Login Button
                SizedBox(
                  width: screenWidth - 2 * padding,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF81A55D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Alegreya',
                        fontSize: 32,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // Sign-up Prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        fontFamily: 'Alegreya Sans',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontFamily: 'Alegreya Sans',
                          fontSize: 16,
                          color: Color(0xFF81A55D),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
