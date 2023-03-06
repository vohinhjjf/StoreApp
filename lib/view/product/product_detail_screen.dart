import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/components/appbar.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/utils/format.dart';

class ProductDetailScreen extends StatefulWidget {
  String id ="id";
  final ProductModel product;
  ProductDetailScreen(this.product,{required this.id});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final Repository _repository = Repository();
  User? user = FirebaseAuth.instance.currentUser;
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: ListAppBar().AppBarProduct(context, "Thông tin sản phẩm", widget.id),
      body: SingleChildScrollView(
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.only(
              //     topRight: Radius.circular(56),
              //     topLeft: Radius.circular(56)),
            ),
            width: size.width,
            //height: 30,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.product.image,
                    //height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(widget.product.name,
                      style: const TextStyle(
                          fontSize: mFontTitle,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(
                    height: 5,
                  ),
                  _buildPrice(),
                  if (widget.product.discountPercentage != 0) Row(
                    children: [
                      Text(
                        '${Format().currency(widget.product.price, decimal: false).replaceAll(RegExp(r','), '.')}đ',
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Text(
                        "${widget.product.discountPercentage}%",
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: mDividerColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Mô tả sản phẩm",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: mFontTitle,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.product.details,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: mFontListTile,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                ],
              ),
            )
        ),
      ),
      bottomSheet: Row(
        children: [
          Flexible(
              flex: 1,
              child: InkWell(
                onTap: () {
                  _repository.addToCart(widget.product).then((value) {
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
              )
          ),
        ],
      ),
    );
  }
  RichText _buildPrice() => RichText(
    text: TextSpan(
      text: '${Format().currency(widget.product.price*(100-widget.product.discountPercentage)/100, decimal: false).replaceAll(RegExp(r','), '.')}đ',
      style: const TextStyle(
          fontSize: 20,
          color: Colors.red,
        fontWeight: FontWeight.bold
      ),
    ),
  );

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
