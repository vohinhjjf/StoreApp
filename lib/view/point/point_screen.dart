import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:countdown_flutter_ns/countdown_flutter_ns.dart';
import 'package:pinput/pinput.dart';
import 'package:store_app/constant.dart';

import '../../Firebase/respository.dart';
import '../../models/customer_model.dart';

class PointScreen extends StatefulWidget {
  @override
  _PointScreenState createState() => _PointScreenState();
}

class _PointScreenState extends State<PointScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  Repository repository = Repository();
  late final TextEditingController pinController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();
  DateTime date = DateTime.now();
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: Color.fromRGBO(234, 239, 243, 1),
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );


  int random() {
    return 100000 + Random().nextInt(899999);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade400,
        centerTitle: true,
        elevation: 0,
        title: const Text('Ưu đãi điểm thưởng', style: TextStyle(color: Colors.white, fontSize: mFontTitle),),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.white,),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: repository.getUserById(user!.uid).asStream(),
          builder: (context, AsyncSnapshot<CustomerModel> snapshot){
            if (snapshot.hasData) {
              if(snapshot.data!.luckyNumber != "") {
                pinController.text = snapshot.data!.luckyNumber;
              }
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                        height: 210,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 50),
                              decoration: BoxDecoration(
                                //color: Colors.lightBlue.shade300,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.lightBlue.shade400, Colors.lightBlue, mPrimaryColor],
                                  stops: [0.1, 0.5, 0.9],
                                ),
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot.data!.point.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: mFontTitle
                                          ),
                                        ),
                                        Icon(Icons.diamond, color: Colors.yellow.shade800),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 90,),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 170,
                                width: MediaQuery.of(context).size.width - 25,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                height: 70,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent.withAlpha(20),
                                                  border: Border.all(color: Colors.redAccent),
                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    const Text("+100",
                                                      style: TextStyle(
                                                          color: Colors.redAccent,
                                                          fontSize: caption1
                                                      ),
                                                    ),
                                                    snapshot.data!.checkin
                                                    ?Icon(Icons.check_circle_outline_rounded, color: Colors.redAccent)
                                                    :Icon(Icons.diamond, color: Colors.yellow.shade800),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 2,),
                                              Text("Hôm nay",
                                                style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: caption1,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 70,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text("+100", style: TextStyle(fontSize: caption1),),
                                                    Icon(Icons.diamond, color: Colors.yellow.shade800),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 2,),
                                              Text("Ngày 2", style: TextStyle(fontSize: caption1),),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 70,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text("+100", style: TextStyle(fontSize: caption1),),
                                                    Icon(Icons.diamond, color: Colors.yellow.shade800),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 2,),
                                              Text("Ngày 3", style: TextStyle(fontSize: caption1),),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 70,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text("+100", style: TextStyle(fontSize: caption1),),
                                                    Icon(Icons.diamond, color: Colors.yellow.shade800),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 2,),
                                              Text("Ngày 4", style: TextStyle(fontSize: caption1),),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 70,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text("+100", style: TextStyle(fontSize: caption1),),
                                                    Icon(Icons.diamond, color: Colors.yellow.shade800),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 2,),
                                              Text("Ngày 5", style: TextStyle(fontSize: caption1),),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 70,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text("+100", style: TextStyle(fontSize: caption1),),
                                                    Icon(Icons.diamond, color: Colors.yellow.shade800),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 2,),
                                              Text("Ngày 6", style: TextStyle(fontSize: caption1),),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                height: 70,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage("assets/images/diamond.jfif"),
                                                  ),
                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 2, left: 5),
                                                  child: Text("+200",
                                                    style: TextStyle(
                                                        fontSize: caption1,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 2,),
                                              Text("Ngày 7", style: TextStyle(fontSize: caption1),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    snapshot.data!.checkin
                                    ?Container(
                                      padding: EdgeInsets.only(top: 5, bottom: 5),
                                      width: MediaQuery.of(context).size.width - 90,
                                      //height: 40,
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16.0)),
                                        color: Colors.grey.shade300,
                                        textColor: Colors.white,
                                        child: const Text("Quay lại vào ngày mai để nhận 100 xu", style: TextStyle(fontSize: subhead)),
                                        enableFeedback: false,
                                        onPressed: () {
                                        },
                                      ),
                                    )
                                    :Container(
                                      padding: EdgeInsets.only(top: 5, bottom: 5),
                                      width: MediaQuery.of(context).size.width - 90,
                                      //height: 40,
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16.0),
                                            side: const BorderSide(color: mPrimaryColor)),
                                        color: mPrimaryColor,
                                        textColor: Colors.white,
                                        child: const Text("Bấm để nhận ngày hôm nay", style: TextStyle(fontSize: subhead)),
                                        onPressed: () {
                                          setState(() {
                                            repository.checkInPoint(100);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: const Text('CHỌN SỐ TRÚNG THƯỞNG',
                            style: TextStyle(
                              fontSize: mFontTitle,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        )
                    ),
                    Container(
                        color: Colors.yellow.shade800,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          //height: 170,
                          width: MediaQuery.of(context).size.width - 25,
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 45),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue.shade400,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10))
                                ),
                                child: Text("PHIÊN CHƠI 00:00 NGÀY ${date.day}/${date.month}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: mFontSize,
                                        fontWeight: FontWeight.bold)
                                ),
                              ),
                              SizedBox(height: 15,),
                              snapshot.data!.luckyNumber == ""
                              ?const Text("CHỌN 6 SỐ CỦA BẠN",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: mFontSize,
                                      fontWeight: FontWeight.bold)
                              )
                              :Text("Kết quả sẽ được cập nhật vào 16:00 ngày ${date.day +1}/${date.month}",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: subhead,)
                              ),
                              SizedBox(height: 15 ,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Directionality(
                                  // Specify direction if desired
                                  textDirection: TextDirection.ltr,
                                  child: Pinput(
                                    length: 6,
                                    controller: pinController,
                                    focusNode: focusNode,
                                    listenForMultipleSmsOnAndroid: true,
                                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                                    defaultPinTheme: defaultPinTheme,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20 ,),
                              snapshot.data!.luckyNumber == ""
                              ?Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    width: MediaQuery.of(context).size.width - 100,
                                    height: 50,
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(

                                          borderRadius: BorderRadius.circular(5.0),
                                          side: const BorderSide(color: mPrimaryColor)),
                                      color: Colors.white,
                                      child: const Text("Chọn dãy số ngẫu nhiên",
                                          style: TextStyle(
                                              fontSize: mFontListTile,
                                              color: Colors.blue
                                          )),
                                      onPressed: () {
                                        setState(() {
                                          pinController.text = "${random()}";
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    width: MediaQuery.of(context).size.width - 100,
                                    height: 50,
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0)),
                                      color: pinController.text.length == 6 ? Colors.lightBlue : Colors.grey,
                                      textColor: Colors.white,
                                      child: const Text("XÁC NHẬN",
                                          style: TextStyle(
                                              fontSize: mFontListTile,
                                              fontWeight: FontWeight.bold
                                          )),
                                      onPressed: () {
                                        if(pinController.text.length == 6) {
                                          _showDialog();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )
                              :Container(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                width: MediaQuery.of(context).size.width - 100,
                                height: 50,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  color: Colors.lightBlue,
                                  textColor: Colors.white,
                                  child: const Text("Mời bạn chơi, x5 cơ hội",
                                      style: TextStyle(
                                          fontSize: mFontListTile,
                                          fontWeight: FontWeight.bold
                                      )),
                                  onPressed: () {

                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 2,
                                color: Colors.grey.shade200,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Center(
                                child: CountdownFormatted(
                                  duration: Duration(hours: 23 - date.hour, minutes: 59 - date.minute, seconds: 60 - date.second),
                                  onFinish: () {
                                    print('finished!');
                                  },
                                  builder: (BuildContext ctx, String remaining) {
                                    final showTime = (String text) => Container(
                                      width: 30,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(horizontal: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                    List<String> time = remaining.split(':').toList();
                                    if (time == null) {
                                      return Container();
                                    }
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text("Thời gian chọn số còn",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: mFontListTile,
                                                fontWeight: FontWeight.bold)
                                        ),
                                        SizedBox(width: 5,),
                                        showTime(time[0]),
                                        showTime(time[1]),
                                        showTime(time[2]),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        )
                    ),
                  ]
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ),

      ),
    );
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Bạn có chắc muốn chọn số",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    "${pinController.text} ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "không?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.redAccent),
                            borderRadius: BorderRadius.all(Radius.circular(3))
                        ),
                        child: const Text('Chọn lại',
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 15)),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        }),
                    MaterialButton(
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        //side: BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                        child: const Text('Chắc chắn',
                            style: TextStyle(
                                color: Colors.white, fontSize: 15)),
                        onPressed: () {
                          setState(() {
                            repository.luckyNumber(pinController.text);
                          });
                          Navigator.of(context, rootNavigator: true).pop();
                        }),
                  ])
            ],
          ),
        ));
  }
}