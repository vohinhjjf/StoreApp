import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../Firebase/payment/stripe_payment_service.dart';
import 'create_new_card_screen.dart';

class CreditCardList extends StatelessWidget {
  static const String id = 'manage-cards';

  @override
  Widget build(BuildContext context) {
    StripeService _service = StripeService();

    return Scaffold(
      appBar: AppBar(
        /*actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: CreateNewCreditCard.id),
                screen: CreateNewCreditCard(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          )
        ],*/
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Quản lý thẻ tín dụng',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _service.cards.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Đã xảy ra sự cố');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Không có thẻ tín dụng nào được thêm vào tài khoản của bạn'),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                    child: const Text(
                      'Thêm thẻ',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      /*pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: CreateNewCreditCard.id),
                        screen: CreateNewCreditCard(),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );*/
                    },
                  )
                ],
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var card = snapshot.data!.docs[index];
                return Slidable(
                  startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // A pane can dismiss the Slidable.
                    dismissible: DismissiblePane(onDismissed: () {}),

                    // All actions are defined in the children parameter.
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        label: 'Xóa',
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        onPressed: (c) {
                          EasyLoading.show(status: 'Vui lòng đợi...');
                          _service.deleteCreditCard(card.id).whenComplete(() {
                            EasyLoading.dismiss();
                          });
                        },
                      ),
                    ],
                  ),
                  //actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: CreditCardWidget(
                      cardNumber: card['cardNumber'],
                      expiryDate: card['expiryDate'],
                      cardHolderName: card['cardHolderName'],
                      cvvCode: card['cvvCode'],
                      backgroundNetworkImage: 'https://th.bing.com/th/id/OIP.dJegwPSS-s84fGCjn6F48AHaGL?pid=ImgDet&rs=1',
                      showBackView: false,
                      obscureCardNumber: true,
                      obscureInitialCardNumber: true,
                      obscureCardCvv: true,
                      isHolderNameVisible: true,
                      isChipVisible: true,
                      isSwipeGestureEnabled: false,
                      onCreditCardWidgetChange: (CreditCardBrand ) {  },
                    ),
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