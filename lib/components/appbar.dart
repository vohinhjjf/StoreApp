import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/view/card/widgets/search.dart';
import 'package:store_app/view/login/welcome_screen.dart';
import 'package:store_app/view/order/product_cart_screen.dart';

class ListAppBar {
  var customerApiProvider = CustomerApiProvider();
  User? user = FirebaseAuth.instance.currentUser;

  AppBar AppBarCart(BuildContext context, String title, Function() onPressed) {
    return AppBar(
      backgroundColor: Colors.lightBlue.shade300,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.white,),
          onPressed: onPressed
      ),
      centerTitle: true,
      title:  Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: mFontTitle),
      ),
    );
  }

  AppBar AppBarHome(BuildContext context, String id) {
    if(id =="")
      {
        id = "id";
      }
    return AppBar(
      backgroundColor: Colors.lightBlue.shade300,
      elevation: 0,
      titleSpacing: 20,
      leadingWidth: 0,
      leading: Container(),
      actions: [
        Container(
          padding: const EdgeInsets.only(top: 5),
          child: Stack(
            children: <Widget>[
              IconButton(
                iconSize: 28,
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  if(prefs.getString('ID') == ''|| prefs.getString('ID') == null){
                    Dialog(context);
                  }
                  else{
                    Navigator.of(context).push(MaterialPageRoute (
                        builder: (BuildContext context) => ProductScreen(prefs.getString('ID')!)));
                  }
                },
                icon: const Icon(MdiIcons.cartOutline,),
                color: Colors.white,
              ),
              StreamBuilder(
                stream: customerApiProvider.cart.doc(id).collection('products').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.hasData){
                    return snapshot.data!.docs.isEmpty
                        ? const SizedBox()
                        : Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 22,
                          minHeight: 22,
                        ),
                        child: Text(
                          '${snapshot.data!.docs.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  else if(snapshot.hasError){
                    return Text(snapshot.error.toString());
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        IconButton(
          iconSize: 28,
          onPressed: () async {

          },
          icon: const Icon(MdiIcons.heartOutline,),
          color: Colors.white,
        ),
        const SizedBox(
          width: 5,
        ),
      ],
      title: Row(
        children: [
          const Icon(Icons.shopping_cart, size: 30,color: Colors.white,),
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: const Text("eShop",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontFamily: "Lobster",
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar AppBarProduct(BuildContext context, String title, String id) {
    if(id =="")
    {
      id = "id";
    }
    return AppBar(
      backgroundColor: Colors.lightBlue.shade300,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      centerTitle: false,
      actions: [
        Container(
          padding: const EdgeInsets.only(top: 5),
          child: Stack(
            children: <Widget>[
              IconButton(
                iconSize: 28,
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  if(prefs.getString('ID') == ''|| prefs.getString('ID') == null){
                    Dialog(context);
                  }
                  else{
                    Navigator.of(context).pushReplacement(MaterialPageRoute (
                        builder: (BuildContext context) => ProductScreen(prefs.getString('ID')!)));
                  }
                },
                icon: const Icon(MdiIcons.cartOutline,),
                color: Colors.white,
              ),
              StreamBuilder(
                stream: customerApiProvider.cart.doc(id).collection('products').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.hasData){
                    return snapshot.data!.docs.isEmpty
                        ? const SizedBox()
                        : Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 22,
                          minHeight: 22,
                        ),
                        child: Text(
                          '${snapshot.data!.docs.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  else if(snapshot.hasError){
                    return Text(snapshot.error.toString());
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        IconButton(
          iconSize: 28,
          onPressed: () async {

          },
          icon: const Icon(MdiIcons.heartOutline,),
          color: Colors.white,
        ),
        const SizedBox(
          width: 5,
        ),
      ],
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: mFontTitle),
      ),
    );
  }

  AppBar AppBarListProduct(BuildContext context, String title, String id) {
    if(id =="")
    {
      id = "id";
    }
    return AppBar(
      backgroundColor: Colors.lightBlue.shade300,
      elevation: 0,
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: mFontSize,
          ),
          onPressed: () => Navigator.of(context).pop()),
      title: Container(
        color: Colors.transparent,
        //padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildSearch(context,title),
                  const SizedBox(width: 8),
                  Stack(
                    children: <Widget>[
                      IconButton(
                        iconSize: 28,
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(prefs.getString('ID') == ''|| prefs.getString('ID') == null){
                            Dialog(context);
                          }
                          else{
                            Navigator.of(context).pushReplacement(MaterialPageRoute (
                                builder: (BuildContext context) => ProductScreen(prefs.getString('ID')!)));
                          }
                        },
                        icon: const Icon(MdiIcons.cartOutline,),
                        color: Colors.white,
                      ),
                      StreamBuilder(
                        stream: customerApiProvider.cart.doc(id).collection('products').snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if(snapshot.hasData){
                            return snapshot.data!.docs.isEmpty
                                ? const SizedBox()
                                : Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 22,
                                  minHeight: 22,
                                ),
                                child: Text(
                                  '${snapshot.data!.docs.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          else if(snapshot.hasError){
                            return Text(snapshot.error.toString());
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 48,
              )
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildSearch(BuildContext context,String title) {
    const border =  OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(4.0),
      ),
    );

    const sizeIcon = BoxConstraints(
      minWidth: 40,
      minHeight: 40,
    );

    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(4),
          focusedBorder: border,
          enabledBorder: border,
          isDense: true,
          hintText: title,
          hintStyle: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white,
            size: 10,
          ),
          prefixIconConstraints: sizeIcon,
          suffixIcon: const Icon(
            Icons.search,
          ),
          suffixIconConstraints: sizeIcon,
          filled: true,
          fillColor: Colors.white,
        ),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute (
            builder: (BuildContext context) => SearchScreen(),
          ));
        },
      ),
    );
  }

   Future Dialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: const [
                Image(image: AssetImage(
                    "assets/images/log.png")),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Vui lòng đăng nhập để tiếp tục!',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return WelcomeScreen();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      'TIẾP TỤC',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'HỦY BỎ',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}