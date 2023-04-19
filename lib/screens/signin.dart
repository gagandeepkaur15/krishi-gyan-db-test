// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello!',
                  style: GoogleFonts.kufam(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You have been missed!',
                  style: GoogleFonts.bentham(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),

                //email text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                //password text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                //sign in
                SizedBox(
                  height: 50,
                  width: 375,
                  child: ElevatedButton(
                    onPressed: () async {
                      dynamic authResult = await _auth.signIn(
                          emailController.text, passwordController.text);
                      if (authResult == null) {
                        print('error signing in');
                      } else {
                        print(authResult);
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, '/sellForm');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 40,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Sign In'),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a Member? '),
                    SizedBox(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(' Register Here!'),
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          alignment: Alignment.topCenter,
                          height: 40,
                          child: IconButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/lp'),
                            icon: const Icon(
                              Icons.facebook,
                              size: 50,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 23, 10, 10),
                          height: 60,
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/lp');
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                              size: 45,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
