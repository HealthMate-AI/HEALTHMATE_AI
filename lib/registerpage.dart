import 'package:flutter/material.dart';
import 'package:healthmate/loginpage.dart';

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

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  void _register() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    setState(() {
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showAlert("All fields are required.");
    } else if (!_isValidEmail(email)) {
      setState(() => emailError = "Enter a valid email address");
    } else if (!_isStrongPassword(password)) {
      setState(() => passwordError = "Use 6+ chars, uppercase, number & symbol");
    } else if (password != confirmPassword) {
      setState(() => confirmPasswordError = "Passwords do not match");
    } else {
      _showAlert("Registered successfully!", success: true);
    }
  }

  bool _isValidEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
}

  bool _isStrongPassword(String password) {
  // Password must be at least 6 characters and include:
  // one uppercase, one lowercase, one digit, and one special character (!@#\$&*~)
  return RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{6,}$'
  ).hasMatch(password);
}

  void _showAlert(String message, {bool success = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          success ? "Success" : "Error",
          style: TextStyle(
            color: success ? const Color(0xFF00A57E) : Colors.redAccent,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Color(0xFF00A57E)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        // title: const Text(
        //   'Create Account',
        //   style: TextStyle(
        //     color: Color(0xFF00A57E),
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF00A57E)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const Center(
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
            inputField(emailController, "Enter your email", Icons.email, errorText: emailError, onChanged: (value) {
              setState(() {
                emailError = _isValidEmail(value) ? null : "Enter a valid email address";
              });
            }),
            const SizedBox(height: 25),

            label("Password"),
            passwordField(
              controller: passwordController,
              obscureText: _obscurePassword,
              toggle: () => setState(() => _obscurePassword = !_obscurePassword),
              errorText: passwordError,
              onChanged: (value) {
                setState(() {
                  passwordError = _isStrongPassword(value) ? null : "Use 6+ chars, uppercase, number & symbol";
                });
              },
            ),
            const SizedBox(height: 25),

            label("Confirm Password"),
            passwordField(
              controller: confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              toggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              errorText: confirmPasswordError,
            ),
            const SizedBox(height: 40),

            GestureDetector(
              onTap: _register,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF00A57E),
                      Color(0xFF056443),
                      Color(0xFF013924),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x9900A57E),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    "Login",
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
    );
  }

  Widget label(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 18),
    );
  }

  Widget inputField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    String? errorText,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        prefixIcon: Icon(icon, color: Color(0xFF00A57E), size: 26),
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

  Widget passwordField({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggle,
    String? errorText,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF00A57E), size: 26),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF00A57E),
          ),
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
