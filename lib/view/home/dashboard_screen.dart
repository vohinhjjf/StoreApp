import 'package:bottom_bar/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:store_app/view/account_screen/account_screen.dart';
import 'package:store_app/view/campaign/campaign_screen.dart';
import 'package:store_app/view/card/card_screen.dart';
import 'package:store_app/view/home/dashboard_screen.dart';
import 'package:store_app/view/support/ChatScreen.dart';
import '../../constant.dart';
import '../support/MessagesPage.dart';

class HomeScreen extends StatefulWidget {
  String id = "";
  HomeScreen({super.key, required this.id});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      CardScreen(id: widget.id),
      CampaignScreen(),
      MessagesPage(),
      AccountScreen()
    ];
    PageController pageController = PageController();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurStyle: BlurStyle.inner,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: widgetOptions,
        ),
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onTap: (int index) {
          pageController.jumpToPage(index);
          setState(() => _selectedIndex = index);
        },
        items: const <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Trang chủ'),
            activeColor: mPrimaryColor,
          ),
          BottomBarItem(
            icon: Icon(MdiIcons.ticketPercent),
            title: Text('Voucher'),
            activeColor: mPrimaryColor,
          ),
          BottomBarItem(
            icon: Icon(MdiIcons.chatProcessingOutline),
            title: Text('Hỗ trợ'),
            activeColor: mPrimaryColor,
          ),
          BottomBarItem(
            icon: Icon(Icons.account_circle_outlined),
            title: Text('Tài khoản'),
            activeColor: mPrimaryColor,
          ),
        ],
      ),
    );
  }
}
