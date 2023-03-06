import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const mPrimaryColor = Colors.blue;
const mSecondPrimaryColor = Color(0xFF2C2C2C);
const mSecondaryColor = Color(0xFFEAEAEA);
const mDividerColor = Color(0xFF14274E);
const mLinear = Color(0xFF848ccf);
const mHighColor = Color(0xFF2962FF);
const mOrangeColor = Colors.orange;
const Color darkGrey = Color(0xff202020);
const mError = Colors.red;

const mFontSize = 18.0;
const mFontTitle = 20.0;
const mFontListTile = 16.0;
const baseUrl = 'http://70.37.98.42/app_dev.php/api';
const webSocket = 'ws://70.37.98.42:8080';

const title1 = 34.0;
const title2 = 22.0;
const title3 = 20.0;
const body = 17.0;
const subhead = 15.0;
const footnote = 13.0;
const caption1 = 12.0;
const caption2 = 11.0;

const space_height = 6.0;

const kPageViewTextStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.w500,
);

TextStyle dayStyle(FontWeight fontWeight) {
  return TextStyle(color: Colors.black, fontWeight: fontWeight);
}
/// Function Format DateTime to String with layout string
String formatNumber(double value) {
  final f = new NumberFormat("#,###", "vi_VN");
  return f.format(value);
}

class Constants {
  static final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  );

  static final BoxShadow cardShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 1,
    blurRadius: 7,
    offset: Offset(0, 3), // changes position of shadow
  );

  static const TextStyle titleService = TextStyle(
      fontSize: mFontSize,
      color: mDividerColor,
      fontWeight: FontWeight.w500);

  static final TextStyle titleProductDetail =
  TextStyle(fontSize: footnote, color: Colors.grey[500]);

  static final TextStyle contentProductDetail =
  TextStyle(fontSize: footnote, color: Colors.black);
}

class FirestoreConstants {
  static const pathUserCollection = "Users";
  static const pathMessageCollection = "messages";
  static const name = "name";
  static const id = "id";
  static const email = "email";
  static const chattingWith = "chattingWith";
  static const idFrom = "idFrom";
  static const idTo = "idTo";
  static const timestamp = "timestamp";
  static const content = "content";
  static const type = "type";
}

class ColorConstants {
  static const themeColor = Color(0xfff5a623);
  static const primaryColor = Color(0xff203152);
  static const greyColor = Color(0xffaeaeae);
  static const greyColor2 = Color(0xffE8E8E8);
}
