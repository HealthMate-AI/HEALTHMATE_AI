import 'package:flutter/material.dart';
import 'package:healthmate/registerpage.dart';
import 'package:healthmate/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Please enter email and password.");
      return;
    }

    setState(() => _loading = true);

    try {
      // Sign in with Firebase Auth
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(uid).get();
      if (!userDoc.exists) {
        _showSnackBar("User profile not found!");
        setState(() => _loading = false);
        return;
      }

      String username = userDoc.get("username");
      String userEmail = userDoc.get("email");

      setState(() => _loading = false);

      // Navigate to Homepage
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(username: username, email: userEmail),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _loading = false);
      String message = "Login failed!";
      if (e.code == "user-not-found") {
        message = "No user found with this email.";
      } else if (e.code == "wrong-password") {
        message = "Incorrect password.";
      }
      _showSnackBar(message);
    } catch (e) {
      setState(() => _loading = false);
      _showSnackBar(e.toString());
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF00A57E),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  "\n\n\nYour Health Companion Begins Here",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF00A57E),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 50),

              const Text("Email Address",
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                  prefixIcon:
                      const Icon(Icons.email, color: Color(0xFF00A57E), size: 26),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: Color(0xFF00A57E), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: Color(0xFF00A57E), width: 2),
                  ),
                  hintText: "Enter your email",
                  hintStyle:
                      const TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),

              const Text("Password",
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                  prefixIcon:
                      const Icon(Icons.lock, color: Color(0xFF00A57E), size: 26),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFF00A57E),
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: Color(0xFF00A57E), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: Color(0xFF00A57E), width: 2),
                  ),
                  hintText: "Enter your password",
                  hintStyle:
                      const TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ),
              const SizedBox(height: 40),

              // Updated Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color(0xFF00A57E),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Color(0xFF00A57E),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
