import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/utils/format.dart';
import 'package:store_app/view/history/components/purchase_detail.dart';

class ListData extends StatefulWidget {
  final String status;

  const ListData({super.key, required this.status});

  @override
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  final customerApiProvider = CustomerApiProvider();
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: customerApiProvider.customer.doc(customerApiProvider.user!.uid)
          .collection("purchase history").where("orderStatus", isEqualTo: widget.status).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.2,
                  ),
                  const Text("Hiện tại không có đơn hàng nào!",
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
          return buildList(snapshot.data!,"Mới nhất");
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildList(QuerySnapshot querySnapshot, String option) {
    return ListView(
        padding: EdgeInsets.only(top: 10),
        children: querySnapshot.docs.map((DocumentSnapshot document) {
          return  buildData(document,option);
        }).toList()
    );
  }

  Widget buildData(DocumentSnapshot document, String option) {
    List<dynamic> list = document['products'];
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
                  Text(widget.status,style: TextStyle(color: Colors.grey.shade700, fontSize: mFontListTile,fontWeight: FontWeight.bold)),
                  SizedBox(height: 5,),
                  Divider(height: 5,color: Colors.grey,),
                  SizedBox(height: 5,),
                  Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Image.network(
                            document["products"][0]["productImage"],
                            height: 100,
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                document["products"][0]["productName"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                const TextStyle(fontSize: mFontListTile, fontWeight: FontWeight.w500),
                              ),
                              Text("Số lượng sản phẩm: ${list.length}",
                                  style: TextStyle(color: Colors.grey, fontSize: mFontListTile)),
                              RichText(
                                text: TextSpan(
                                  text: 'Tổng tiền: ${Format().currency(document["total"], decimal: false).replaceAll(RegExp(r','), '.')}đ',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  OutlinedButton(
                                    autofocus: true,
                                    style: OutlinedButton.styleFrom(
                                      //minimumSize: MediaQuery.of(context).size,
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(color: mPrimaryColor, width: 1),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(5))
                                        )
                                    ),
                                    onPressed:() {
                                        Navigator.of(context).push(
                                            MaterialPageRoute (builder: (BuildContext context) => PurchaseDetail(purchaseId: document.id,status: widget.status,)));
                                    },
                                    child: const Text(
                                      "Xem chi tiết",
                                      style:  TextStyle(fontSize: mFontListTile, color: mPrimaryColor),
                                    )),
                                  widget.status=="Đang xử lý"
                                      ?OutlinedButton(
                                      autofocus: true,
                                      style: OutlinedButton.styleFrom(
                                        //minimumSize: MediaQuery.of(context).size,
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(color: mError, width: 1),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(5))
                                          )
                                      ),
                                      onPressed:() {
                                        print(document.id);
                                        Dialog1(
                                            context,
                                            document.id,
                                            'Bạn muốn hủy đơn hàng này?',
                                            Image(image: AssetImage(
                                                "assets/images/cancel.png"))
                                        );
                                      },
                                      child: const Text(
                                        "Hủy đơn",
                                        style:  TextStyle(fontSize: mFontListTile, color: mError),
                                      ))
                                      :OutlinedButton(
                                      autofocus: true,
                                      style: OutlinedButton.styleFrom(
                                        //minimumSize: MediaQuery.of(context).size,
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(color: mPrimaryColor, width: 1),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(5))
                                          )
                                      ),
                                      onPressed:() {
                                        Dialog1(context
                                            , document.id,
                                            'Bạn muốn mua lại đơn hàng này?',
                                            Image(image: AssetImage(
                                                "assets/images/repurchase.png"))
                                        );
                                      },
                                      child: const Text(
                                        "Mua lại",
                                        style:  TextStyle(fontSize: mFontListTile, color: mPrimaryColor),
                                      )),
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

  Dialog1(BuildContext context, String orderId, String logan, Image image) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children:  [
                image,
                SizedBox(
                  height: 6,
                ),
                Text(
                  logan,
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
                      if(logan == "Bạn muốn hủy đơn hàng này?") {
                        customerApiProvider.statusOrder(orderId, "Đơn đã hủy")
                            .whenComplete(() {
                          Navigator.of(context).pop();
                          Dialog2(context, 'Đã hủy đơn hàng');
                        });
                      }else{
                        customerApiProvider.statusOrder(orderId, "Đang xử lý")
                            .whenComplete(() {
                          Navigator.of(context).pop();
                          Dialog2(context, 'Đang xử lý đơn hàng');
                        });
                      }
                    },
                    child: const Text(
                      'ĐỒNG Ý',
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

  Dialog2(BuildContext context, String logan) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          _timer = Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.5),
            title: Column(
              children: [
                Image(image: AssetImage(
                    "assets/images/nutmeg.gif")),
                SizedBox(
                  height: 6,
                ),
                Text(
                  logan,
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