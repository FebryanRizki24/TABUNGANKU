import 'package:cobaprojek1/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isPasswordVisible = false;
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get userChanges => _firebaseAuth.authStateChanges();

  get authStateChanges => null;

  Future<bool> signInWithEmailAndPassword() async {
    String email = _controllerEmail.text.trim();
    String password = _controllerPassword.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Email and password are required.';
      });
      return false;
    }

    Future<User?> signInWithEmailAndPassword({
      required String email,
      required String password,
    }) async {
      try {
        final UserCredential userCredential =
            await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return userCredential.user;
      } catch (e) {
        // Handle the authentication error (e.g., show an error message).
        print('Error during sign-in: $e');
        return null;
      }
    }

    try {
      final userCredential =
          await signInWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        // Pengguna ditemukan, login berhasil
        return true;
      } else {
        // Pengguna tidak ditemukan, login gagal
        setState(() {
          errorMessage = 'No user found.';
        });
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        setState(() {
          errorMessage = 'Wrong password provided for that user.';
        });
      } else {
        setState(() {
          errorMessage = 'An error occurred during sign-in: ${e.message}';
        });
      }
      setState(() {
        isLogin = false;
      });
      return false; // Login gagal
    } catch (error) {
      setState(() {
        errorMessage = 'An unexpected error occurred during sign-in.';
      });
      setState(() {
        isLogin = false;
      });
      return false; // Login gagal
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            SizedBox(
              height: 50,
              child: TextButton(
                child: Text('Forgot Password?'),
                onPressed: () {},
              ),
              width: size.width,
            ),
            ElevatedButton(
                onPressed: () {
                  signInWithEmailAndPassword().then((isLoginSuccesfull) {
                    if (isLoginSuccesfull) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return MainPage();
                      }));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(errorMessage ?? "Login failed")));
                    }
                  });
                },
                child: Text('Sign In'))
          ],
        )),
      ],
    );
  }
}
