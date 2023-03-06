import 'package:flutter/material.dart';
import 'package:store_app/components/appbar.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/view/account_info/components/body.dart';

class AccountInfoScreen extends StatefulWidget {
  AccountInfoScreen({Key? key}) : super(key: key);

  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: ListAppBar().AppBarCart(
          context,
          "Thông tin tài khoản",
          () => Navigator.of(context).pop()),
      body: Body(),
    );
  }
}
