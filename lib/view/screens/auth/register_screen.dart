import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool signUp(email, password, confirmPassword, context) {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill out all fields.")),
      );
      return false;
    }

    try {
      if (password == confirmPassword) {
        FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match.")),
        );
        return false;
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred during sign-up')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
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
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              children: [
                SizedBox(height: height * 0.2),

                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Alegreya',
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
                SizedBox(height: height * 0.15),
                // Email Label
                SizedBox(
                  width: width * 0.85,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontFamily: 'Alegreya',
                        fontSize: 23,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2),
                SizedBox(
                  width: width * 0.85,
                  height: 40,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.03),
                SizedBox(
                  width: width * 0.85,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontFamily: 'Alegreya',
                        fontSize: 23,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2),

                SizedBox(
                  width: width * 0.85,
                  height: 40,
                  child: TextField(
                    controller: passwordController,
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

                SizedBox(height: height * 0.03),
                SizedBox(
                  width: width * 0.85,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontFamily: 'Alegreya',
                        fontSize: 23,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2),
                // Confirm Password Box
                SizedBox(
                  width: width * 0.85,
                  height: 40,
                  child: TextField(
                    controller: confirmPasswordController,
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

                SizedBox(height: height * 0.05),
                // Sign-Up Button
                SizedBox(
                  width: width * 0.85,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      bool isSuccess = signUp(
                        emailController.text,
                        passwordController.text,
                        confirmPasswordController.text,
                        context,
                      );
                      if (isSuccess) {
                        Navigator.pushNamed(context, '/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF81A55D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontFamily: 'Alegreya',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontFamily: 'Alegreya Sans',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Log in',
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
