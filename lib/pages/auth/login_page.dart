import 'package:cobaprojek1/pages/auth/signIn.dart';
import 'package:cobaprojek1/pages/auth/signUp.dart';
import 'package:cobaprojek1/pages/auth/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showSignUp = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HeaderAuth(),
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: size.width * 0.5,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  showSignUp = true;
                                });
                              },
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              style: showSignUp
                                  ? ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          LinearBorder.bottom(
                                              side: BorderSide(
                                                  width: 3,
                                                  color: Colors.purple))))
                                  : ButtonStyle(),
                            )),
                        SizedBox(
                            width: size.width * 0.5,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    showSignUp = false;
                                  });
                                },
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                style: showSignUp
                                    ? ButtonStyle()
                                    : ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                            LinearBorder.bottom(
                                                side: BorderSide(
                                                    width: 3,
                                                    color: Colors.purple)))))),
                      ],
                    ),
                    showSignUp ? SignUpPage() : SignInPage(),
                  ],
                ),
              ),
              Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}