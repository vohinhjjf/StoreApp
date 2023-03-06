import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/components/appbar.dart';
import 'package:store_app/view/campaign/components/voucher.dart';
import 'package:store_app/view/home/dashboard_screen.dart';
import 'package:ticketview/ticketview.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/models/address_model.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/utils/format.dart';
import 'package:store_app/view/order/delivery_address.dart';
import 'package:store_app/view/order/product_cart_screen.dart';

class ConfirmOrderPage extends StatefulWidget {
  String id;
  bool checkFreeShip, checkVoucher;
  String Discount, Freeship;
  double maxDiscount;
  ConfirmOrderPage(this.id, this.checkFreeShip, this.checkVoucher, this.Discount, this.maxDiscount, this.Freeship);
  @override
  _ConfirmOrderPageWidgetState createState() => _ConfirmOrderPageWidgetState();
}
class _ConfirmOrderPageWidgetState extends State<ConfirmOrderPage> with SingleTickerProviderStateMixin{

  var customerApiProvider = CustomerApiProvider();
  final Repository _repository = Repository();
  int delivery = -1;
  double total = 0, discount = 0;
  List<CartModel> list_cartModel = [];
  late AddressModel addressModel;

  setDiscount(){
    double result = double.parse(widget.Discount)*total/100;
    double max = widget.maxDiscount*1000;
    setState((){
      if(result > max){
        print('trên');
        discount = max;
      }
      else {
        print("dưới");
        discount = result;
      }
    });
  }
  @override
  void initState() {
    _repository.getTotal().then((value) {
      setState((){
        total = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setDiscount();
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: ListAppBar().AppBarCart(
            context, "Thanh toán",
            () => Navigator.of(context).pushReplacement(
              MaterialPageRoute (
                builder: (BuildContext context) => ProductScreen(widget.id),
              ),
            )
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 90,
              child: ListView(
                children: <Widget>[
                  StreamBuilder(
                    stream: customerApiProvider.customer.doc(widget.id).collection('address')
                        .where('mac_dinh',isEqualTo: true).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.hasData){
                        if(snapshot.data!.docs.isEmpty){
                          return Container(
                            margin: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Card(
                              elevation: 0,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)), border: Border.all(color: Colors.grey.shade200)),
                                padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
                                child: Column(
                                  children: [
                                    const Text("Chưa có địa chỉ"),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      color: Colors.grey.shade300,
                                      height: 1,
                                      width: double.infinity,
                                    ),
                                    addressAction("Thêm")
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        addressModel = snapshot.data!.docs.map((e) => AddressModel.fromMap(e)).first;
                        return selectedAddressSection(addressModel);
                      }
                      else if(snapshot.hasError){
                        return Text(snapshot.error.toString());
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  standardDelivery(),
                  checkoutItem(),
                  voucherSection(),
                  priceSection()
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: MaterialButton(
                  onPressed: () {
                    /*Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => OrderPlacePage()));*/
                    print(widget.maxDiscount);
                    if(delivery == -1){
                      showBottomSheet(context);
                    }
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text(
                    "Thanh toán",
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white,
        elevation: 2,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200, width: 2),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
            child: Column(
              children: <Widget>[
                ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: Container(
                      width: 30,
                      height: 30,
                      child: const Center(
                        child: Icon(Icons.payments, color: Colors.lightBlue,),
                      ),
                    ),
                    title: const Text('Thanh toán khi nhận hàng'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      EasyLoading.show(status: 'Vui lòng đợi...');
                      _repository.addPurchaseHistory(list_cartModel,addressModel, total, discount, double.parse(widget.Freeship)*1000, widget.checkFreeShip, widget.checkVoucher).whenComplete(() {
                        EasyLoading.dismiss();
                        EasyLoading.showSuccess('Đơn đặt hàng của bạn đã được gửi').whenComplete(() {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute (
                                builder: (BuildContext context) =>  HomeScreen(id: prefs.getString("ID")!),
                              ), (route) => false);
                        });
                      });
                    }
                ),
                Container(
                  color: Colors.grey.shade300,
                  height: 1,
                  width: double.infinity,
                ),
                ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: Container(
                      width: 30,
                      height: 30,
                      child: const Center(
                        child: Icon(Icons.credit_card, color: Colors.lightBlue,),
                      ),
                    ),
                    title: const Text('Thẻ ATM nội địa'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
                    onTap: (){}
                ),
              ],
            ),
          );
        },
        context: (context)
    );
  }

  selectedAddressSection(AddressModel addressModel) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)), border: Border.all(color: Colors.grey.shade200)),
          padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${addressModel.ten} (Mặc định)",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.all(Radius.circular(16))),
                    child: Text(
                      addressModel.loai_dia_chi,
                      style:
                      TextStyle(color: Colors.indigoAccent.shade200, fontSize: 8),
                    ),
                  )
                ],
              ),
              createAddressText(addressModel.dia_chi, 16),
              createAddressText("${addressModel.xa}, ${addressModel.huyen}, ${addressModel.tinh}", 6),
              const SizedBox(
                height: 6,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Số điện thoại: ",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade800)),
                  TextSpan(
                      text: addressModel.so_dien_thoai,
                      style: const TextStyle(color: Colors.black, fontSize: 12)),
                ]),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                color: Colors.grey.shade300,
                height: 1,
                width: double.infinity,
              ),
              addressAction("Thay đổi")
            ],
          ),
        ),
      ),
    );
  }

  createAddressText(String strAddress, double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
      ),
    );
  }

  addressAction(String text) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute (
                  builder: (BuildContext context) => const DeliveryAddressPage(),
                ),
              );
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(text,
                style: TextStyle(fontSize: 12, color: Colors.indigo.shade700)),
          ),
        ],
      ),
    );
  }

  standardDelivery() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
          color: Colors.tealAccent.withOpacity(0.2)),
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio<int>(
            value: -1,
            groupValue: delivery,
            onChanged: (isChecked) {
              setState((){
                delivery = isChecked ?? 1;
                print(isChecked);
              });
            },
            activeColor: Colors.tealAccent.shade400,
            toggleable: true,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Giao hàng tiêu chuẩn",
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Nhận nó trước 20/11 - 27/11",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  checkoutItem() {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)), border: Border.all(color: Colors.grey.shade200)),
          padding: const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: StreamBuilder(
            stream: customerApiProvider.cart.doc(widget.id).collection('products').where("checkbuy", isEqualTo: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasData){
                list_cartModel = snapshot.data!.docs.isEmpty ? []
                : snapshot.data!.docs.map((e) => CartModel.fromMap(e)).toList();
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
        ),
      ),
    );
  }

  BuildList(List<CartModel> list_cartModel){
    return ListView.builder(
      //padding: const EdgeInsets.only(bottom: 150),
      shrinkWrap: true,
      itemCount: list_cartModel.length,
      itemBuilder: (context, index) {
        return checkoutListItem(list_cartModel[index]);
      },
    );
  }

  checkoutListItem(CartModel product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
            child: Image.network(
              product.productImage,
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
                width: MediaQuery.of(context).size.width-120,
                child: Text(
                  product.productName,
                  style: const TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Số lượng: ${product.amount}',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '${Format().currency(product.price*(100-product.discountPercentage)/100, decimal: false).replaceAll(RegExp(r','), '.')}đ',

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

  voucherSection(){
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: Colors.grey.shade200)
      ),
      child: MaterialButton(
        elevation: 0,
        onPressed: (){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute (
              builder: (BuildContext context) => Voucher(widget.id),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(MdiIcons.ticketConfirmation, color: Colors.deepOrange,),
                SizedBox(width: 5,),
                Text("Voucher", style: TextStyle(color: Colors.deepOrange,fontSize: 14),),
              ],
            ),
            Row(
              children: [
                widget.checkVoucher ? Container(
                  height: 30,
                  width: 65,
                  color: Colors.grey,
                  margin: const EdgeInsets.all(10),
                  child: TicketView(
                    backgroundColor: Colors.white,
                    backgroundPadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.zero,
                    contentBackgroundColor: Colors.deepOrange,
                    drawDivider: false,
                    trianglePos: 10,
                    child: Center(
                      child: Text("-${(discount/1000).toInt()}k",style: const TextStyle(color: Colors.white,fontSize: 12),),
                    ),
                  ),
                ) : Container(),
                widget.checkFreeShip ? Container(
                  height: 30,
                  width: 135,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TicketView(
                    backgroundColor: Colors.white,
                    backgroundPadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.zero,
                    contentBackgroundColor: Colors.teal.shade300,
                    drawDivider: false,
                    trianglePos: 4,
                    child: const Center(
                      child: Text("Miễn phí vận chuyển",style: TextStyle(color: Colors.white,fontSize: 12),),
                    ),
                  ),
                ) : Container(),
                const Icon(Icons.navigate_next)
              ],
            )
          ],
        ),
      ),
    );
  }

  priceSection() {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)), border: Border.all(color: Colors.grey.shade200)),
          padding: const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 4,
              ),
              const Text(
                "Chi tiết thanh toán",
                style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
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
              createPriceItem("Tổng tiền hàng", '${Format().currency(total, decimal: false).replaceAll(RegExp(r','), '.')}đ', Colors.grey.shade700, 13),
              createPriceItem("Phí vận chuyển", '${Format().currency(35000, decimal: false).replaceAll(RegExp(r','), '.')}đ', Colors.grey.shade700, 13),
              widget.checkFreeShip ? createPriceItem("Giảm giá phí vận chuyển", '-${Format().currency(double.parse(widget.Freeship)*1000, decimal: false).replaceAll(RegExp(r','), '.')}đ', Colors.teal.shade300, 13): Container(),
              widget.checkVoucher ? createPriceItem("Combo khuyến mãi", '-${Format().currency(discount, decimal: false).replaceAll(RegExp(r','), '.')}đ', Colors.red, 13) : Container(),
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
                    "Total",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  Text(
                    '${Format().currency(total+35000-double.parse(widget.Freeship)*1000 - discount, decimal: false).replaceAll(RegExp(r','), '.')}đ',
                    style: TextStyle(color: Colors.orange.shade700, fontSize: 14),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String getFormattedCurrency(double amount) {
    MoneyFormatter fmf = MoneyFormatter(amount: amount);
    fmf.settings!
      ..symbol = "₹"
      ..thousandSeparator = ","
      ..decimalSeparator = "."
      ..fractionDigits = 2;
    return fmf.output.symbolOnLeft;
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
}