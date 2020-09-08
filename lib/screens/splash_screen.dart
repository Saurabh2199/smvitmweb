import 'package:flutter/material.dart';
import 'package:smvitm_web/screens/select_category_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool code = false;

  _initialize() async {
    Navigator.of(context).pushReplacementNamed(SelectCategoryScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    if (!code) {
      code = !code;
      _initialize();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/icons/logo_color.png',
                height: _mediaQuery.width * 0.2,
                width: _mediaQuery.width * 0.2,
                fit: BoxFit.contain,
              )),
          Positioned(
            bottom: _mediaQuery.height * 0.08,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  "Developed By",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "X to Infinity",
                  style: TextStyle(fontSize: 16, fontFamily: 'Vampire'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
