import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/product_model.dart';

class AddToCartWidget extends StatefulWidget {
  final ProductModel productModel;
  const AddToCartWidget(this.productModel);
  @override
  _AddToCartWidgetState createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  final Repository _repository = Repository();
  User? user = FirebaseAuth.instance.currentUser;
  bool _loading = true;
  late Timer _timer;

  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() async {
    final snapshot =
    await  FirebaseFirestore.instance.collection('Cart').doc(user!.uid).collection('products').get();
    if (snapshot.docs.isEmpty) {
      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Nếu sản phẩm này tồn tại trong giỏ hàng, cần nhận được thông tin chi tiết
    /*FirebaseFirestore.instance
        .collection('Cart')
        .doc(user!.uid)
        .collection('products')
        .where('productId', isEqualTo: widget.document['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        if (doc['productId'] == widget.document['productId']) {
        //Nghĩa là sản phẩm đã chọn đã tồn tại trong giỏ hàng, vì vậy không cần thêm lại vào giỏ hàng
          setState(() {
            _exist = true;
            _qty = doc['qty'];
            _docId = doc.id;
          });
        }
      }),
    });*/

    return _loading
        ? SizedBox(
      height: 56,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ),
    )
        : InkWell(
          onTap: () {
            _repository.addToCart(widget.productModel).then((value) {
              setState(() {
                Dialog(context);
              });
            });
          },
          child: Container(
            height: 56,
            color: Colors.red[400],
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      MdiIcons.cartOutline,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Thêm vào giỏ hàng',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
  Dialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          _timer = Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.5),
            title: Column(
              children: const [
                Icon(
                  MdiIcons.checkboxMarkedCircle,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Đã thêm vào giỏ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }).then((val){
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }
}