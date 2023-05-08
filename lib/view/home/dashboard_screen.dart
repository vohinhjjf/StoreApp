import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:store_app/view/account_screen/account_screen.dart';
import 'package:store_app/view/campaign/campaign_screen.dart';
import 'package:store_app/view/card/card_screen.dart';
import 'package:store_app/view/support/MessagesPage.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../Firebase/respository.dart';
import '../../constant.dart';
import '../extensions/extensions_screen.dart';

class HomeScreen extends StatefulWidget {
  String id = "";
  HomeScreen({super.key, required this.id});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  User? user = FirebaseAuth.instance.currentUser;
  final _repository = Repository();
  var nameController = TextEditingController();
  bool category = false;

  @override
  void initState() {
    super.initState();
    showInputNamePopup();
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
      ExtensionsScreen(),
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
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: widgetOptions,
        ),
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          // iconSize: 32,
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
          // opacity: 0.3,
        ),
        items: [
          BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Trang chủ'),
            selectedColor: mPrimaryColor,
          ),
          BottomBarItem(
            icon: Icon(MdiIcons.ticketPercent),
            title: Text('Voucher'),
            selectedColor: mPrimaryColor,
          ),
          BottomBarItem(
            icon: Icon(MdiIcons.ticketPercent, color: Colors.white,),
            title: Text(''),
            selectedColor: Colors.white,
            unSelectedColor: Colors.white
          ),
          BottomBarItem(
            icon: Icon(MdiIcons.chatProcessingOutline),
            title: Text('Hỗ trợ'),
            selectedColor: mPrimaryColor,
          ),
          BottomBarItem(
            icon: Icon(Icons.account_circle_outlined),
            title: Text('Tài khoản'),
            selectedColor: mPrimaryColor,
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: _selectedIndex,
        onTap: (index) {
          category = false;
          pageController.jumpToPage(index);
          setState(() => _selectedIndex = index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            category = true;
            _selectedIndex = 2;
            pageController.jumpToPage(2);
          });
        },
        backgroundColor: Colors.white,
        child: Image.asset(
          "assets/icons/menu.png",
          width: 40,
          height: 40,
          color: category==false ? Colors.grey : null,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void showInputNamePopup() {
    if (user != null) {
      _repository.getUserById(user!.uid).then((value) => {
            if (value.name == '') {_displayTextInputDialog(context)}
          });
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Trước khi mua sắm \nChúng tôi muốn biết tên của bạn'),
          content: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
                labelText: 'Nhập tên của bạn',
                labelStyle: TextStyle(fontSize: mFontSize),
                contentPadding: EdgeInsets.zero),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('OK'),
              onPressed: () {
                setState(
                  () {
                    if (nameController.text == '') {
                      Fluttertoast.showToast(
                          msg: 'Vui lòng cung cấp thông tin',
                          backgroundColor: ColorConstants.greyColor);
                    } else {
                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(user?.uid)
                          .update({'name': nameController.text},);
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: 'Cảm ơn bạn đã cung cấp thông tin',
                          backgroundColor: ColorConstants.greyColor);
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
