import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/view/home/dashboard_screen.dart';
import 'package:store_app/view/login/mobile_number.dart';
import 'package:store_app/view/login/onboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final Key _mapKey = UniqueKey();
  static const String id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        //padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: OnBoardScreen(),
            ),
            const Text(
              'Đăng nhập để có thể trải nghiệm mua hàng tốt hơn',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 1300),
              duration: const Duration(milliseconds: 1000),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => MobileNumber()));
                        },
                        color: Colors.blue,
                        height: 45,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 4),
                        child: const Center(
                          child: Text("ĐĂNG NHẬP", style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                          ),),
                        )
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute (
                                builder: (BuildContext context) => HomeScreen(id: ""),
                              )
                          );
                        },
                        child: const Text("BỎ QUA", style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.8,
                            color: Colors.blue
                        ),)
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}