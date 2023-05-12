import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/customer_model.dart';

class DetailInfo extends StatefulWidget {
  @override
  _DetailInfoState createState() => _DetailInfoState();
}
class _DetailInfoState extends State<DetailInfo> {
  late Future<CustomerModel?> _value;
  final user = FirebaseAuth.instance.currentUser;
  final _repository = Repository();
  
  @override
  initState() {
    super.initState();
    //_value = _repository.getCustomerData();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: FutureBuilder<CustomerModel?>(
          future: _repository.getUserById(user!.uid),
          builder: (
              BuildContext context,
              AsyncSnapshot<CustomerModel?> snapshot,
              ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Visibility(
                    visible: snapshot.hasData,
                    child: const Text(
                      'snapshot.data',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  )
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 30),
                        dense: true,
                        leading: const FaIcon(
                          FontAwesomeIcons.user,
                          color: mPrimaryColor,
                          size: mFontSize,
                        ),
                        title: Text(snapshot.data!.name,
                            style: const TextStyle(fontSize: mFontSize)),
                      ),
                      Divider(height: 10,color: Colors.blue[100],indent: 20,endIndent: 20),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 30),
                        dense: true,
                        leading: const FaIcon(
                          FontAwesomeIcons.birthdayCake,
                          color: mPrimaryColor,
                          size: mFontSize,
                        ),
                        title: Text(snapshot.data!.birthday, style: const TextStyle(fontSize: mFontSize)),
                      ),
                      Divider(height: 10,color: Colors.blue[100],indent: 20,endIndent: 20),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 30),
                        dense: true,
                        leading: const FaIcon(
                          FontAwesomeIcons.location,
                          color: mPrimaryColor,
                          size: mFontSize,
                        ),
                        title: Text(snapshot.data!.address,
                            style: const TextStyle(fontSize: mFontSize)),
                      ),
                      Divider(height: 10,color: Colors.blue[100],indent: 20,endIndent: 20),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 30),
                        dense: true,
                        leading: const FaIcon(
                          FontAwesomeIcons.phone,
                          color: mPrimaryColor,
                          size: mFontSize,
                        ),
                        title: Text(snapshot.data!.number, style: const TextStyle(fontSize: mFontSize)),
                      ),
                      Divider(height: 10,color: Colors.blue[100],indent: 20,endIndent: 20),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 30),
                        dense: true,
                        leading: const FaIcon(
                          FontAwesomeIcons.envelope,
                          color: mPrimaryColor,
                          size: mFontSize,
                        ),
                        title: Text(snapshot.data!.email,
                            style: const TextStyle(fontSize: mFontSize)),
                      ),
                    ],
                  ),
                );
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }
}
