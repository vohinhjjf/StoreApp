import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/utils/format.dart';
import 'package:store_app/view/history/components/purchase_detail.dart';
import 'package:store_app/view/review/components/review_detail.dart';

import '../../../models/cart_model.dart';

class ListNotReview extends StatefulWidget {

  const ListNotReview({super.key});

  @override
  _ListNotReviewState createState() => _ListNotReviewState();
}

class _ListNotReviewState extends State<ListNotReview> {
  final customerApiProvider = CustomerApiProvider();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: customerApiProvider.customer.doc(customerApiProvider.user!.uid)
            .collection("purchase history").where("orderStatus", isEqualTo: "Đã nhận hàng").snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
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
            return buildList(snapshot.data!);
          }
          else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error.toString()}");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(QuerySnapshot querySnapshot) {
    return ListView(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.only(top: 10),
        children: querySnapshot.docs.map((DocumentSnapshot document) {
          return  buildListNotReview(document);
        }).toList()
    );
  }

  Widget buildListNotReview(DocumentSnapshot documentSnapshot) {
    return StreamBuilder(
      stream: customerApiProvider.customer.doc(customerApiProvider.user!.uid)
          .collection("purchase history").doc(documentSnapshot.id)
          .collection('products').where("reviewStatus", isEqualTo: false).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return Container();
          }
          List<CartModel> list = snapshot.data!.docs.map((e) => CartModel.fromMap2(e)).toList();
          print("List: ${list.length}");
          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            //padding: const EdgeInsets.only(top: 10),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return buildData(list[index]);
            },
          );
        }
        else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error.toString()}");
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildData(CartModel cartModel) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          shadowColor: Colors.grey,
          elevation: 4,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          //margin: EdgeInsets.fromLTRB(5, space_height, 5, 0),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () async {

            },
            child: Container(
              width: 300,
              height: 185,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                crossAxisAlignment : CrossAxisAlignment.start,
                children: [
                  Text("Đã hoàn thành",style: TextStyle(color: Colors.grey.shade700, fontSize: mFontListTile,fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5,),
                  const Divider(height: 5,color: Colors.grey,),
                  const SizedBox(height: 5,),
                  Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Image.network(
                            cartModel.productImage,
                            height: 100,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                cartModel.productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                const TextStyle(fontSize: mFontListTile, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 5,),
                              Text("Số lượng: ${cartModel.amount}",
                                  style: const TextStyle(color: Colors.grey, fontSize: mFontListTile)),
                              const SizedBox(height: 5,),
                              RichText(
                                text: TextSpan(
                                  text: 'Giá tiền x1: ${Format().currency(cartModel.price, decimal: false).replaceAll(RegExp(r','), '.')}đ',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                      autofocus: true,
                                      style: OutlinedButton.styleFrom(
                                        //minimumSize: MediaQuery.of(context).size,
                                          backgroundColor: Colors.redAccent,
                                          side: const BorderSide(color: Colors.redAccent, width: 1),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                          )
                                      ),
                                      onPressed:() {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ReviewDetail(cartModel: cartModel);
                                            },
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Đánh giá",
                                        style:  TextStyle(fontSize: mFontListTile, color: Colors.white),
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ]
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}