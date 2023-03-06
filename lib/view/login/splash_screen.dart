import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/view/home/dashboard_screen.dart';
import 'package:store_app/view/login/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var auth = AuthProvider();

  @override
  void initState() {
    Timer(
        const Duration(
          seconds: 6
        ), () {
      checkID();
    });

    super.initState();
  }

  checkID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('ID') == ''|| prefs.getString('ID') == null){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute (
          builder: (BuildContext context) => WelcomeScreen(),
        ),
      );
    }
    else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute (
          builder: (BuildContext context) => HomeScreen(id: prefs.getString('ID')!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png'),
            TextLiquidFill(
              text: 'eShop',
              waveColor: Colors.lightBlue,
              boxBackgroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
                fontFamily: "Lobster"
              ),
              boxHeight: 160.0,
            ),
          ],
        ),
      ),
    );
  }
}