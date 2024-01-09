import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobaprojek1/pages/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isPasswordVisible = false;
  String? errorMessage = '';
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      // Handle the registration error (e.g., show an error message).
      print('Error during registration: $e');
      return null;
    }
  }

  Future<bool> registerWithEmailAndPassword() async {
    String email = _controllerEmail.text.trim();
    String password = _controllerPassword.text.trim();
    String confirmPassword = _controllerConfirmPassword.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        errorMessage = 'All fields are required.';
      });
      return false;
    }

    if (password != confirmPassword) {
      setState(() {
        errorMessage = 'Passwords do not match.';
      });
      return false;
    }

    try {
      await createUserWithEmailAndPassword(email: email, password: password);
      final user = FirebaseAuth.instance.currentUser; // Get the current user

      if (user != null) {
        // Pendaftaran berhasil

        // Store user information in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': _controllerUsername.text.trim(),
          'email': email,
          // You can store other user information here
        });

        return true;
      } else {
        setState(() {
          errorMessage = 'Registration failed.';
        });
        return false;
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An unexpected error occurred during registration.';
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 11),
        Form(
            child: Column(
          children: [
            TextFormField(
                controller: _controllerEmail,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: InputBorder.none,
                  filled: true,
                )),
            SizedBox(height: 11),
            TextFormField(
                controller: _controllerPassword,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                    hintText: 'Password',
                    border: InputBorder.none,
                    filled: true,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: Icon(isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined)))),
            SizedBox(height: 11),
            TextFormField(
                controller: _controllerConfirmPassword,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    border: InputBorder.none,
                    filled: true,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: Icon(isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined)))),
            SizedBox(height: 11),
            ElevatedButton(
                onPressed: () {
                  registerWithEmailAndPassword()
                      .then((isRegistrationSuccessful) {
                    if (isRegistrationSuccessful) {
                      // Navigasi ke DashboardScreen jika pendaftaran berhasil
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }));
                    } else {
                      // Tampilkan pesan kesalahan jika pendaftaran gagal
                      if (errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage ??
                                "Registration failed. Please check your credentials."),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Registration failed. Please check your credentials."),
                          ),
                        );
                      }
                    }
                  }).catchError((error) {
                    // Handle error jika ada kesalahan lainnya (opsional)
                  });
                },
                child: Text('Sign Up'))
          ],
        )),
      ],
    );
  }
}
