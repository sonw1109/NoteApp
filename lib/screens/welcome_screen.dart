import 'package:flutter/material.dart';
import 'package:note_app/screens/login_screen.dart';
import 'package:note_app/screens/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 50, 22, 100),
            child: Image.asset('assets/images/welcome_image.png'),
          ),
          const Text(
            "Discover Your\nDream Job Here",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w500,
              color: Color(0xff1F41BB),
            ),
          ),
          Container(
            height: 20,
          ),
          const Text(
            "Explore all the existing job roles based on your\ninterest and study major",
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 50),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    backgroundColor: const Color(0xff1F41BB),
                    overlayColor: Colors.white,
                  ),
                  child: const Text(
                    'Log in',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => SignupScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                      side: BorderSide.none,
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
