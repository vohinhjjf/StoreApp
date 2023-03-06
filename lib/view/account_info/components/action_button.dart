import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constant.dart';

import 'replace_user.dart';

class ActionButton extends StatefulWidget {
  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      color: mSecondaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: mPrimaryColor)),
            color: mPrimaryColor,
            textColor: Colors.white,
            child: Text('Sửa thông tin',
                style: TextStyle(
                    fontSize: mFontSize, fontWeight: FontWeight.w400)),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Repair_user()));
            },
          ),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Colors.deepOrange)),
            color: Colors.deepOrange,
            textColor: Colors.white,
            child: Text('Đổi mật khẩu',
                style: TextStyle(
                    fontSize: mFontSize, fontWeight: FontWeight.w400)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
