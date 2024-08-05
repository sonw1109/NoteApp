import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/providers/firebase_auth_implementatiton/firebase_auth_services.dart';
import 'package:note_app/screens/home_page.dart';
import 'package:note_app/screens/login_screen.dart';
import 'package:note_app/screens/welcome_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(firebaseAuthServiceProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 20),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                          },
                          icon: Icon(Icons.chevron_left)),
                      Container(
                        width: 25,
                      ),
                      const Text(
                        "Create account",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1F41BB),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Text(
                    "Create an account so you can explore all the\nexisting job",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      filled: true, // Đặt thành true để hiển thị màu nền
                      fillColor: const Color(0xffF1F4FF), // Màu nền của ô nhập liệu
                      labelText: 'Email',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue[900]!,
                          width: 1.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text!";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      filled: true, // Đặt thành true để hiển thị màu nền
                      fillColor: const Color(0xffF1F4FF), // Màu nền của ô nhập liệu
                      labelText: 'Password',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue[900]!,
                          width: 1.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text!";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      filled: true, // Đặt thành true để hiển thị màu nền
                      fillColor: const Color(0xffF1F4FF), // Màu nền của ô nhập liệu
                      labelText: 'Confirm Password',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue[900]!,
                          width: 1.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                    onPressed: () async {
                      final user = await authService.signUpWithEmailAndPassword(
                          context,
                          _emailController.text,
                          _passwordController.text,
                          _confirmPasswordController.text);
                      if (user != null) {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                          double.infinity, 60), // Chiều rộng và chiều cao tối thiểu của nút
                      padding: EdgeInsets.zero, // Bỏ padding nếu muốn kích thước nút cố định
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      overlayColor: Colors.white,
                      backgroundColor: const Color(0xff1F41BB),
                    ),
                    child: const Text(
                      "Sign up",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: const Text(
                      "Already have an account",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xff494949),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          endIndent: 10, // Khoảng cách giữa Divider và Text
                        ),
                      ),
                      Text(
                        "Or continue with",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1F41BB),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          indent: 10, // Khoảng cách giữa Text và Divider
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      final user = await authService.signInWithGoogle();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/google.png'),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff494949),
                            ),
                            children: [
                              TextSpan(
                                text: '  Login with ',
                              ),
                              TextSpan(
                                text: 'Google',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/facebook.png'),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff494949),
                          ),
                          children: [
                            TextSpan(
                              text: '  Login with ',
                            ),
                            TextSpan(
                              text: 'Facebook',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
