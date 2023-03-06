import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/constant.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Repair_user extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Repair();
}

class Repair extends State{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  var name = TextEditingController();
  var birthday = TextEditingController();
  var address = TextEditingController();
  var cmd = TextEditingController();
  var number = TextEditingController();
  var email = TextEditingController();

  CalendarFormat format = CalendarFormat.month;
  late CalendarController _calendarController;
  late DateTime _currentDate = DateTime.now();
  final _repository = Repository();


  updateProfile(){
    return FirebaseFirestore.instance.collection('Users').doc(user?.uid).update({
      'name' : name.text,
      'birthday' : birthday.text,
      'address' : address.text,
      'number' : number.text,
      'email' : email.text,
    });
  }

  getDataUser(){
    _repository.getUserById(user!.uid).then((value) => {
    if(mounted){
        setState(() {
          number.text = value.number;
          birthday.text = value.birthday;
        })
      }
    });
  }

  @override
  void initState() {
    getDataUser();
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Cập nhật hồ sơ',
          style:  TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomSheet: InkWell(
        onTap: (){
          if(_formKey.currentState!.validate()){
            EasyLoading.show(status: 'Đang cập nhật hồ sơ...');
            updateProfile().then((value){
              EasyLoading.showSuccess('Cập nhật thành công');
              Navigator.pop(context);
            });
          }
        },
        child: Container(
          width: double.infinity,
          height: 56,
          color: Colors.blueGrey[900],
          child: const Center(
            child: Text(
              'Cập nhật',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(width: 60,),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                    labelText: 'Họ và Tên',
                    labelStyle: TextStyle(fontSize: mFontSize),
                    contentPadding: EdgeInsets.zero
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),

              //birthday
              SizedBox(
                child: Padding(padding: const EdgeInsets.fromLTRB(0,10.0,0,10.0),
                  child: TextFormField(
                    controller: birthday,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Ngày tháng năm sinh',
                        labelStyle: const TextStyle(fontSize: mFontSize),
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: IconButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1921, 1, 1),
                              maxTime: DateTime.now(), onChanged: (date) {
                                /* print(
                          'change $date in time zone ${date.timeZoneOffset.inHours.toString()}',
                        ); */
                              }, onConfirm: (date) {
                                //print('confirm $date');
                                String formattedDate =
                                DateFormat('dd / MM / yyyy').format(date);
                                setState(() {
                                  birthday.text = formattedDate;
                                });
                              },
                              currentTime: birthday.text == ''
                                  ?DateTime.now()
                                  :DateFormat('dd / MM / yyyy').parse(birthday.text),
                              locale: LocaleType.en,
                              theme: const DatePickerTheme(
                                containerHeight: 270,
                              ));
                        },
                          icon: const Icon(
                            Icons.calendar_today,
                            color: mPrimaryColor,
                          ),
                        ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Vui lòng nhập ngày tháng năm sinh';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              //nationality
              SizedBox(
                child: Padding(padding: const EdgeInsets.fromLTRB(0,10.0,0,10.0),
                  child: TextFormField(
                    controller: address,
                    decoration: const InputDecoration(
                        labelText: 'Địa chỉ',
                        labelStyle: TextStyle(fontSize: mFontSize),
                        contentPadding: EdgeInsets.zero
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Vui lòng nhập địa chỉ';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              //phone
              SizedBox(
                child: Padding(padding: const EdgeInsets.fromLTRB(0,10.0,0,10.0),
                  child:TextFormField(
                  controller: number,
                  enabled: false,
                  decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                      labelStyle: const TextStyle(fontSize: mFontSize),
                      contentPadding: EdgeInsets.zero
                    ),
                  ),
                ),
              ),
              //email
              SizedBox(
                child: Padding(padding: const EdgeInsets.fromLTRB(0,10.0,0,10.0),
                  child:  TextFormField(
                controller: email,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: mFontSize),
                    contentPadding: EdgeInsets.zero
                ),
              ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}