import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/view/home/dashboard_screen.dart';

class Verificatoin extends StatefulWidget {
  final String verificationId;
  final String number;
  const Verificatoin({ Key? key, required this.verificationId, required this.number }) : super(key: key);

  @override
  _VerificatoinState createState() => _VerificatoinState();
}

class _VerificatoinState extends State<Verificatoin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Repository repository = Repository();
  final auth = AuthProvider();
  bool _isResendAgain = false;
  bool _isLoading = false;

  String _code = '';

  late Timer _timer;
  int _start = 60;
  int _currentIndex = 0;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex++;

          if (_currentIndex == 3)
            _currentIndex = 0;
        });
      }
    });

    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 250,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: _currentIndex == 0 ? 1 : 0, 
                        duration: const Duration(seconds: 1,),
                        curve: Curves.linear,
                        child: Image.network('https://img.freepik.com/premium-vector/password-code-verification-security-protection-authorization-notice-mobile-phone-digital-secure-access-pus-notification-message-cellphone-vector-flat_212005-111.jpg?w=740',),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: _currentIndex == 1 ? 1 : 0, 
                        duration: const Duration(seconds: 1),
                        curve: Curves.linear,
                        child: Image.network('https://img.freepik.com/free-vector/new-message-concept-landing-page_23-2148319537.jpg?w=996&t=st=1665070128~exp=1665070728~hmac=6f6a623fe6566cfa1c9e655e8fd060f4b748da19ef2aac983eff6f864658cbc9',),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: _currentIndex == 2 ? 1 : 0, 
                        duration: const Duration(seconds: 1),
                        curve: Curves.linear,
                        child: Image.network('https://img.freepik.com/free-vector/sign-page-abstract-concept-illustration_335657-2242.jpg?w=740&t=st=1665070234~exp=1665070834~hmac=543dd8a2c0db40a096fa3ede3b6a0d490942a406126f8b3f2bd75045338de29f',),
                      ),
                    )
                  ]
                ),
              ),
              const SizedBox(height: 30,),
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: const Text("MÃ OTP", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),
              const SizedBox(height: 30,),
              FadeInDown(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 500),
                child: Text("Vui lòng nhập mã 6 chữ số được gửi tới",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade500, height: 1.5),),
              ),
              const SizedBox(height: 30,),

              // Verification Code Input
              FadeInDown(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 500),
                child: VerificationCode(
                  length: 6,
                  textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                  underlineColor: Colors.black,
                  keyboardType: TextInputType.number,
                  underlineUnfocusedColor: Colors.black,
                  onCompleted: (value) {
                    setState(() {
                      _code = value;
                    });
                  }, 
                  onEditing: (value) {},
                ),
              ),


              const SizedBox(height: 20,),
              FadeInDown(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Không nhận được OTP?", style: TextStyle(fontSize: 14, color: Colors.grey.shade500),),
                    TextButton(
                      onPressed: () {
                        if (_isResendAgain)
                          {return;}
                        auth.verifyPhone(context: context, number: widget.number);
                        resend();
                      }, 
                      child: Text(/*_isResendAgain ? "Thử lại trong $_start" : */"Gửi lại", style: const TextStyle(color: Colors.blueAccent),)
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50,),
              FadeInDown(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 500),
                child: MaterialButton(
                  elevation: 0,
                  onPressed: _code.length < 6 ? () => {} : () async {
                    try {
                      _isLoading = true;
                      PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: _code);
                      final User? user = (await _auth.signInWithCredential(phoneAuthCredential)).user;

                      if (user != null) {
                        repository.checkID(user.uid).then((snapShot) {
                          if (snapShot.exists) {
                            //Dữ liệu người dùng đã tồn tại
                            print('Dữ liệu người dùng đã tồn tại');
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute (
                                  builder: (BuildContext context) => HomeScreen(id: user.uid),
                                )
                            );
                          }
                          else {
                            print('Chưa có dữ liệu người dùng');
                            repository.createUserData(user.uid, user.phoneNumber!);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute (
                                  builder: (BuildContext context) => HomeScreen(id: user.uid),
                                )
                            );
                          };
                          setPrefsID();
                        });

                      } else {
                        _isLoading = false;
                        print('Đăng nhập thất bại');
                      }
                    } catch (e) {
                      _isLoading = false;
                      print('OTP không hợp lệ');
                    }
                  },
                  color: _code.length <6 ? Colors.grey : Colors.blue,
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: _isLoading ? Container(
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 3,
                      color: Colors.black,
                    ),
                  ) : const Text("Xác thực", style: TextStyle(color: Colors.white, fontSize: 18),),
                ),
              )
          ],)
        ),
      )
    );
  }

  Future<void> setPrefsID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ID', _auth.currentUser!.uid);
    print('Chưa xóa');
  }
}
