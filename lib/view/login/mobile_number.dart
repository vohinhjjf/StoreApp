import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/view/login/welcome_screen.dart';

class MobileNumber extends StatefulWidget {

  @override
  _MobileNumberState createState() => _MobileNumberState();
}

class _MobileNumberState extends State<MobileNumber> {
  final auth = AuthProvider();
  bool _validPhoneNumber = false;
  final _phoneNumberController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'VN');

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset : false,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            height: screenHeight - keyboardHeight,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //const SizedBox(height: 100,),
                Visibility(
                  visible: auth.error == 'Invalid OTP'? true : false,
                  child: Column(
                    children: [
                      Text(auth.error,style: const TextStyle(color: Colors.red,fontSize: 12),),
                      const SizedBox(height: 5,),
                    ],
                  ),
                ),
                const Text(
                  'SỐ ĐIỆN THOẠI',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 30,),
                const Text(
                  'Vui lòng nhập số điện thoại hợp lệ của bạn. Chúng tôi sẽ gửi cho bạn mã 6 chữ số để xác minh tài khoản.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 60,
                ),
                FadeInDown(
                  delay: Duration(milliseconds: 400),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black.withOpacity(0.13)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffeeeeee),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            print(number.phoneNumber);
                          },
                          onInputValidated: (bool value) {
                            print(value);
                            setState((){
                              _validPhoneNumber = value;
                            });
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          initialValue: number,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: const TextStyle(color: Colors.black),
                          textFieldController: _phoneNumberController,
                          formatInput: false,
                          maxLength: 10,
                          keyboardType:
                          const TextInputType.numberWithOptions(signed: true, decimal: true),
                          cursorColor: Colors.black,
                          inputDecoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 15, left: 0),
                            border: InputBorder.none,
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                          ),
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                        Positioned(
                          left: 90,
                          top: 8,
                          bottom: 8,
                          child: Container(
                            height: 40,
                            width: 1,
                            color: Colors.black.withOpacity(0.13),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: _validPhoneNumber ? false:true,
                        child: MaterialButton(
                          onPressed: () {
                            setState((){
                              auth.loading=true;
                            });
                            String number ='+84${_phoneNumberController.text}';
                            auth.verifyPhone(context: context, number: number).then((value){
                              _phoneNumberController.clear();
                            });
                            print(number);
                          },
                          height: 50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          color: _validPhoneNumber ? Colors.blue : Colors.grey,
                          child: auth.loading ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ): Text(_validPhoneNumber ? 'TIẾP TỤC' : 'NHẬP SỐ ĐIỆN THOẠI',style: const TextStyle(color: Colors.white),),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 0,
                ),
                TextButton(
                    onPressed: (){
                      Navigator.of(context).push( MaterialPageRoute(
                          builder: (context) => WelcomeScreen()));
                    },
                    child: const Text(
                      'Quay lại',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                      ),
                    )
                )
              ],
            ),
          ),
        )
    );
  }
}