import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', email = '', password = '', confirmPassword = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 🔹 Background Image
          Positioned.fill(
            child: Image.asset('assets/signin.png', fit: BoxFit.cover),
          ),

          // 🔹 Foreground Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            Image.asset('assets/logo.png', height: 80),
                            const SizedBox(height: 20),
                            const Text(
                              "Create your Mot Mot Mind account",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // 🔹 Form Fields
                            SizedBox(
                              width: 280,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildInputField(
                                    "Name",
                                    onChanged: (val) => name = val,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInputField(
                                    "Email",
                                    onChanged: (val) => email = val,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildPasswordField(
                                    "Password",
                                    obscure: _obscurePassword,
                                    onChanged: (val) => password = val,
                                    onToggle: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _buildPasswordField(
                                    "Confirm Password",
                                    obscure: _obscureConfirmPassword,
                                    onChanged: (val) => confirmPassword = val,
                                    onToggle: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFFFF6D2C),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      final isValid =
                                          _formKey.currentState?.validate() ??
                                          false;
                                      if (isValid) {
                                        signUp(name, email, password, context);
                                      }
                                    },
                                    child: const Text('Sign Up'),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // 🔹 Already have an account?
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/sign_in');
                              },
                              child: const Text(
                                'Already have an account? Log In',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            const SizedBox(height: 12),
                            const Text(
                              "Sign up with",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 🔹 Social Buttons
                            SizedBox(
                              width: 280,
                              child: Column(
                                children: [
                                  _buildSocialButton(
                                    iconPath: 'assets/google.png',
                                    label: 'Sign up with Google',
                                    onPressed: () =>
                                        debugPrint("Google SignUp pressed"),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildSocialButton(
                                    iconPath: 'assets/facebook.png',
                                    label: 'Sign up with Facebook',
                                    onPressed: () =>
                                        debugPrint("Facebook SignUp pressed"),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label, {
    bool obscure = false,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          obscureText: obscure,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(bottom: 4),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) return 'Please enter your $label';
            return null;
          },
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label, {
    required bool obscure,
    required Function(String) onChanged,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          obscureText: obscure,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.only(bottom: 4),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
              onPressed: onToggle,
            ),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) return 'Please enter your $label';
            if (label == "Confirm Password" && val != password) {
              return 'Passwords do not match';
            }
            return null;
          },
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String iconPath,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, height: 20, width: 20),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
