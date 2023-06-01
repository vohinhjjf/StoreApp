import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Firebase/payment/stripe_payment_service.dart';
import '../../../components/appbar.dart';
import '../../home/dashboard_screen.dart';

class ExistingCardsPage extends StatefulWidget {
   String value;
   Future<void> addPurchaseHistory;

  ExistingCardsPage({Key? key, required this.value, required this.addPurchaseHistory}) : super(key: key);

  @override
  ExistingCardsPageState createState() => ExistingCardsPageState();
}

class ExistingCardsPageState extends State<ExistingCardsPage> {
  final StripeService _service = StripeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ListAppBar().AppBarCart(
          context, "Chọn thẻ hiện có",
              () => Navigator.of(context).pop()
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _service.cards.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Đã xảy ra sự cố');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return const Center(
              child: Text(
                  'Không có thẻ tín dụng nào được thêm vào tài khoản của bạn '),
            );
          }
          return Container(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var card = snapshot.data!.docs[index];
                return InkWell(
                  onTap: () async {
                    if(widget.value == "confirm"){
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      EasyLoading.show(status: 'Vui lòng đợi...');
                      widget.addPurchaseHistory.whenComplete(() {
                        EasyLoading.dismiss();
                        EasyLoading.showSuccess('Đơn đặt hàng của bạn đã được gửi').whenComplete(() {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute (
                                builder: (BuildContext context) =>  HomeScreen(id: prefs.getString("ID")!),
                              ), (route) => false);
                        });
                      });
                    }
                  },
                  child: CreditCardWidget(
                    cardNumber: card['cardNumber'],
                    expiryDate: card['expiryDate'],
                    cardHolderName: card['cardHolderName'],
                    cvvCode: card['cvvCode'],
                    cardType: CardType.mastercard,
                    backgroundNetworkImage: 'https://th.bing.com/th/id/OIP.NXuQNHbxmZPhK079UABBagHaEk?pid=ImgDet&rs=1',
                    showBackView: false,
                    obscureCardNumber: true,
                    obscureInitialCardNumber: true,
                    obscureCardCvv: true,
                    isHolderNameVisible: true,
                    isChipVisible: true,
                    isSwipeGestureEnabled: false,
                    onCreditCardWidgetChange: (CreditCardBrand ) {  },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
