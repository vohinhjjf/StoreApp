import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/components/appbar.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/utils/format.dart';
import 'package:store_app/view/order/components/confirm_cart.dart';
import 'package:store_app/view/product/product_detail_screen.dart';

class ProductScreen extends StatefulWidget {
  String id;
  ProductScreen(this.id, {Key? key}) : super(key: key);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var customerApiProvider = CustomerApiProvider();
  final Repository _repository = Repository();
  late Timer _timer;
  double total = 0;
  bool loading = false;

  @override
  initState() {
    _repository.getTotal().then((value) {
      setState((){
        total = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      resizeToAvoidBottomInset: false,
      appBar: ListAppBar().AppBarCart(
          context, "Giỏ hàng",
          () => Navigator.of(context).pop()
      ),
      body: StreamBuilder(
        stream: customerApiProvider.cart.doc(widget.id).collection('products').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData){
            List<CartModel> list_cartModel = snapshot.data!.docs.map((e) => CartModel.fromMap(e)).toList();
            if (snapshot.data!.docs.isEmpty) {
              list_cartModel = [];
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.2,
                    ),
                    const Text("Hiện tại không có sản phẩm nào!",
                        style: TextStyle(
                            color: Colors.grey, fontSize: mFontSize)),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SvgPicture.asset(
                      "assets/images/empty.svg",
                      height: size.height * 0.3,
                    ),
                  ],
                ),
              );
            }
            return BuildList(list_cartModel);
          }
          else if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomSheet: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200,width: 1.5)
          )
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Tổng cộng',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${Format().currency(total, decimal: false).replaceAll(RegExp(r','), '.')}đ',
                      style: const TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      '(Bao gồm tất cả thuế)',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
                MaterialButton(
                    color: Colors.redAccent,
                    height: 45,
                    shape: RoundedRectangleBorder(
                      //side: const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      if(total == 0){
                        Dialog(context);
                      }
                      else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ConfirmOrderPage(
                                    widget.id, false, false, '0', 0, '0'
                                ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'THANH TOÁN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: mFontListTile
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BuildList(List<CartModel> list_cartModel){
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80,top: 15),
      itemCount: list_cartModel.length,
      itemBuilder: (context, index) {
        return productInfo(list_cartModel[index]);
      },
    );
  }

  Widget productInfo(CartModel cartItem) {
    var name = cartItem.productName;
    return Card(
      shadowColor: Colors.grey,
      elevation: 3,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      //margin: EdgeInsets.fromLTRB(5, space_height, 5, 0),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          _repository.getCartId(cartItem.productId).then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ProductDetailScreen(value,id: prefs.getString('ID')!);
                },
              ),
            );
          });
        },
        child: Container(
          width: 300,
          height: 155,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Image.network(
                    cartItem.productImage,
                  ),
                ),
                const SizedBox(width: 5,),
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                        const TextStyle(fontSize: mFontListTile, fontWeight: FontWeight.w500),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPrice(cartItem),
                          (loading == true)
                              ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              )
                              : Checkbox(
                              value: cartItem.checkbuy,
                              onChanged: (value){
                                setState((){
                                  loading = true;
                                });
                                _repository.setCheckBuy(cartItem.productId, value!).then((value1) => {
                                  setState(() {
                                    cartItem.checkbuy = value;
                                    loading = false;
                                    if(cartItem.checkbuy) {
                                      total = total +
                                          cartItem.amount * cartItem.price *
                                              (100 -
                                                  cartItem.discountPercentage) /
                                              100;
                                      _repository.setTotal(total);
                                    }
                                    else if(total > 0) {
                                      total = total -
                                          cartItem.amount * cartItem.price *
                                              (100 -
                                                  cartItem.discountPercentage) /
                                              100;
                                      _repository.setTotal(total);
                                    }
                                  })
                                });
                              }
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 28,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (cartItem.amount > 1) {
                                      cartItem.amount--;
                                      _repository.setAmount(cartItem.productId, cartItem.amount).then((value) => {
                                        setState(() {
                                          cartItem.amount=cartItem.amount;
                                          if(cartItem.checkbuy) {
                                            total = total -
                                                cartItem.price *
                                                    (100 -
                                                        cartItem.discountPercentage) /
                                                    100;
                                            _repository.setTotal(total);
                                          }
                                        }),
                                      });
                                    }
                                  },
                                  child: Container(
                                    child: Icon(
                                      cartItem.amount == 1 ? Icons.delete_outline : Icons.remove,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: double.infinity,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(vertical: BorderSide(color: Colors.grey)),
                                  ),
                                  child: Center(
                                      child: FittedBox(
                                          child: /*_updating ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                            ),
                                          ) : */Text(
                                            cartItem.amount.toString(),
                                            style: const TextStyle(color: Colors.black),
                                          ))),
                                ),
                                InkWell(
                                  onTap: () {
                                    cartItem.amount++;
                                    _repository.setAmount(cartItem.productId, cartItem.amount).then((value) => {
                                        setState(() {
                                          cartItem.amount=cartItem.amount;
                                          if(cartItem.checkbuy) {
                                            total = total +
                                                cartItem.price *
                                                    (100 -
                                                        cartItem.discountPercentage) /
                                                    100;
                                            _repository.setTotal(total);
                                          }
                                        }),
                                    });
                                    print(cartItem.productName);
                                  },
                                  child: Container(
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]
          ),

        ),
      ),
    );
  }

  Column _buildPrice(CartModel product) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: '${Format().currency(product.price*(100-product.discountPercentage)/100, decimal: false).replaceAll(RegExp(r','), '.')}đ',
          /*'${MoneyFormatter(
              amount: product.price*(100-product.discountPercentage)/100
          ).output.withoutFractionDigits}đ',*/
          style: const TextStyle(
              fontSize: 16,
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      if (product.discountPercentage != 0) Row(
        children: [
          Text(
            '${Format().currency(product.price, decimal: false).replaceAll(RegExp(r','), '.')}đ',
            softWrap: true,
            style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough
            ),
          ),
          const SizedBox(width: 5,),
          Text(
            "${product.discountPercentage}%",
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ],
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
                  MdiIcons.closeCircleOutline,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Chưa có sản phẩm',
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
