import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/view/home/dashboard_screen.dart';
import 'package:store_app/view/login/welcome_screen.dart';

import '../../components/text_fill/TextFill.dart';

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

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[
      Color(0xff56b2ea),
      Color(0xff50addf),
      Color(0xff3d87b3),
      //Color(0xff3880b7),
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/logo.PNG'),
            TextFill(
              text: 'eShop',
              waveColor: linearGradient,
              boxBackgroundColor: Colors.white,
              textStyle: const TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lobster",
              ),
              boxHeight: 160.0,
            ),
          ],
        ),
      ),
    );
  }
}