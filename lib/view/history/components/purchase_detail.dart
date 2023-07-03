import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/utils/format.dart';

class PurchaseDetail extends StatefulWidget{
  final String purchaseId, status;

  const PurchaseDetail({super.key, required this.purchaseId, required this.status});
  @override
  _PurchaseDetailState createState() => _PurchaseDetailState();
}

class _PurchaseDetailState extends State<PurchaseDetail> {
  final customerApiProvider = CustomerApiProvider();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: mPrimaryColor,
                size: mFontListTile,
              ),
              onPressed: () => Navigator.of(context).pop()),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Đơn hàng',
            style: TextStyle(
              fontSize: mFontTitle,
              color: mPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
          color: Colors.grey.shade300,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 90,
                child: StreamBuilder(
                  stream: customerApiProvider.customer.doc(customerApiProvider.user!.uid).collection('purchase history')
                      .doc(widget.purchaseId).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                    if(snapshot.hasData){
                      if(snapshot.data!.exists){
                        return buildData(snapshot.data!);
                      }
                      return Container();
                    }
                    else if(snapshot.hasError){
                      return Text(snapshot.error.toString());
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade400))
                  ),
                  child: widget.status=="Đang xử lý"?Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: OutlinedButton(
                      onPressed: () {
                        Dialog1(
                            context,
                            widget.purchaseId,
                            'Bạn muốn hủy đơn hàng này?',
                            Image(image: AssetImage(
                                "assets/images/cancel.png"))
                        );
                      },
                      autofocus: true,
                      style: OutlinedButton.styleFrom(
                        //minimumSize: MediaQuery.of(context).size,
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: mError, width: 1),
                          shape: const RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(5))
                          )
                      ),
                      child:  Text(
                        "Hủy đơn",
                        style: TextStyle(color: mError, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ):Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: OutlinedButton(
                      onPressed: () {
                        Dialog1(context
                            , widget.purchaseId,
                            'Bạn muốn mua lại đơn hàng này?',
                            Image(image: AssetImage(
                                "assets/images/repurchase.png"))
                        );
                      },
                      autofocus: true,
                      style: OutlinedButton.styleFrom(
                        //minimumSize: MediaQuery.of(context).size,
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: mPrimaryColor, width: 1),
                          shape: const RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(5))
                          )
                      ),
                      child:  Text(
                        "Mua lại",
                        style: TextStyle(color: mPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  buildData(DocumentSnapshot document){
    List<dynamic> list = [];
    return ListView(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                width: 15,
              ),
              Icon(Icons.list_alt,color: mPrimaryColor,),
              const SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mã Đơn Hàng: ${widget.purchaseId}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Ngày đặt hàng: ${document["orderDate"]}",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    document["orderStatus"],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                width: 15,
              ),
              Icon(Icons.location_on_outlined,color: mPrimaryColor,),
              const SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Địa chỉ người nhận",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    document["nameRecipient"],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  Text(
                    document["phoneRecipient"],
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width-50,
                    child: Text(
                      document["addressRecipient"],
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Icon(Icons.shopping_cart_outlined,color: mPrimaryColor,),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    "Sản phẩm",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              StreamBuilder(
                  stream: customerApiProvider.customer.doc(customerApiProvider.user!.uid)
                      .collection("purchase history").doc(document.id)
                      .collection("products").snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Container();
                      }
                      List list = snapshot.data!.docs;
                      return ListView.builder(
                        //padding: const EdgeInsets.only(bottom: 150),
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return buildItem(list[index]);
                        },
                      );
                    }
                    else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.delivery_dining_outlined,color: mPrimaryColor,),
              const SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Hình Thức Giao Hàng",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Giao hàng tiêu chuẩn",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.payments_outlined,color: mPrimaryColor,),
              const SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Hình Thức Thanh Toán",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Thanh toán tiền mặt khi nhận hàng",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 4,
              ),
              const Text(
                "Chi tiết thanh toán",
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              const SizedBox(
                height: 8,
              ),
              createPriceItem("Tổng tiền hàng", '${Format().currency(document["total"], decimal: false).replaceAll(RegExp(r','), '.')}đ', Colors.grey.shade700, 16),
              createPriceItem("Phí vận chuyển", '${Format().currency(35000, decimal: false).replaceAll(RegExp(r','), '.')}đ', Colors.grey.shade700, 16),
              document["checkFreeShip"] ? createPriceItem("Giảm giá phí vận chuyển", '-${Format().currency(document["freeship"], decimal: false).replaceAll(RegExp(r','), '.')}đ', Colors.teal.shade300, 16): Container(),
              document["checkVoucher"] ? createPriceItem("Combo khuyến mãi", '-${Format().currency(document["discount"], decimal: false).replaceAll(RegExp(r','), '.')}đ', Colors.red, 16) : Container(),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Thành tiền",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Text(
                    '${Format().currency(document["total"]+35000-document["freeship"] - document["discount"], decimal: false).replaceAll(RegExp(r','), '.')}đ',
                    style: TextStyle(color: Colors.orange.shade700, fontSize: 16),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  buildItem(dynamic document) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
            child: Image.network(
              document["productImage"],
              width: 65,
              height: 65,
              fit: BoxFit.fitHeight,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width-110,
                child: Text(
                  document["productName"],
                  style: const TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Số lượng: ${document["amount"]}',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '${Format().currency(document["price"]*(100-document["discountPercentage"])/100, decimal: false).replaceAll(RegExp(r','), '.')}đ',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  createPriceItem(String key, String value, Color color, double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            key,
            style: TextStyle(color: Colors.grey.shade700, fontSize: fontSize),
          ),
          Text(
            value,
            style: TextStyle(color: color, fontSize: fontSize),
          )
        ],
      ),
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
    late Timer _timer;
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