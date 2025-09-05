import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthmate/homepage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    setState(() {
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    // Validate inputs
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar("All fields are required.");
      return;
    } else if (!_isValidEmail(email)) {
      setState(() => emailError = "Enter a valid email address");
      return;
    } else if (!_isStrongPassword(password)) {
      setState(() => passwordError = "Use 6+ chars, uppercase, number & symbol");
      return;
    } else if (password != confirmPassword) {
      setState(() => confirmPasswordError = "Passwords do not match");
      return;
    }

    setState(() => _loading = true);

    try {
      // 1️⃣ Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // 2️⃣ Store user info in Firestore
      await _firestore.collection("users").doc(uid).set({
        "username": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });

      // 3️⃣ Navigate to Homepage with user details
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Homepage(username: name, email: email),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Registration failed!";
      if (e.code == "email-already-in-use") message = "This email is already registered.";
      if (e.code == "invalid-email") message = "Email format is invalid.";
      if (e.code == "weak-password") message = "Password should be at least 6 characters.";
      _showSnackBar(message);
    } catch (e) {
      _showSnackBar("Something went wrong. Please try again.");
    } finally {
      if (mounted) setState(() => _loading = false); // stop spinner always
    }
  }

  bool _isValidEmail(String email) =>
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);

  bool _isStrongPassword(String password) =>
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{6,}$').hasMatch(password);

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF00A57E)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "\nCreate Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF00A57E),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            label("Full Name"),
            inputField(nameController, "Enter your name", Icons.person),
            const SizedBox(height: 25),
            label("Email Address"),
            inputField(emailController, "Enter your email", Icons.email, errorText: emailError),
            const SizedBox(height: 25),
            label("Password"),
            passwordField(controller: passwordController, obscureText: _obscurePassword,
                toggle: () => setState(() => _obscurePassword = !_obscurePassword),
                errorText: passwordError),
            const SizedBox(height: 25),
            label("Confirm Password"),
            passwordField(controller: confirmPasswordController, obscureText: _obscureConfirmPassword,
                toggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                errorText: confirmPasswordError),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  backgroundColor: const Color(0xFF00A57E),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                    : const Text(
                        "Register",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Color(0xFF00A57E), fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget label(String text) =>
      Text(text, style: const TextStyle(color: Colors.white70, fontSize: 18));

  Widget inputField(TextEditingController controller, String hint, IconData icon, {String? errorText}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        prefixIcon: Icon(icon, color: const Color(0xFF00A57E), size: 26),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00A57E), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00A57E), width: 2),
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 16),
        errorText: errorText,
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }

  Widget passwordField({required TextEditingController controller, required bool obscureText,
    required VoidCallback toggle, String? errorText}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF00A57E), size: 26),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF00A57E)),
          onPressed: toggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00A57E), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00A57E), width: 2),
        ),
        hintText: "Enter your password",
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 16),
        errorText: errorText,
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
