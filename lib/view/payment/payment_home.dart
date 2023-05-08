import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../Firebase/payment/stripe_payment_service.dart';
import '../../components/appbar.dart';
import '../../providers/order_provider.dart';
import 'create_new_card_screen.dart';
import 'stripe/existing-cards.dart';

class PaymentHome extends StatefulWidget {
  PaymentHome({Key? key}) : super(key: key);

  @override
  PaymentHomeState createState() => PaymentHomeState();
}

class PaymentHomeState extends State<PaymentHome> {
  onItemPress(BuildContext context, int index, amount, orderProvider) async {
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute (
            builder: (BuildContext context) => CreateNewCreditCard(),
          ),
        );
        break;
      case 1:
        payViaNewCard(context, amount, orderProvider);
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute (
            builder: (BuildContext context) => ExistingCardsPage(),
          ),
        );
        break;
    }
  }

  payViaNewCard(
      BuildContext context, amount, OrderProvider orderProvider) async {
    await EasyLoading.show(status: 'Vui lòng đợi...');
    var response = await StripeService.payWithNewCard(
        amount: '${amount}00', currency: 'USD');
    if (response.success == true) {
      orderProvider.success = true;
    }
    await EasyLoading.dismiss();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: new Duration(
              milliseconds: response.success == true ? 1200 : 3000),
        ))
        .closed
        .then((_) {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    //StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: ListAppBar().AppBarCart(
          context, "Thẻ tín dụng",
              () => Navigator.of(context).pop()
      ),
      body: Column(
        children: [
          /*Material(
            elevation: 4,
            child: SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/8305/8305524.png',
                    fit: BoxFit.fill,
                  ),
                )),
          ),*/
          Container(
            padding: EdgeInsets.all(20),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Image image = Image.asset('assets/icons/credit-card.png');
                  Text text = Text('Thêm thẻ');

                  switch (index) {
                    case 0:
                      image = Image.asset('assets/icons/credit-card.png');
                      text = Text('Thêm thẻ');
                      //TODO : add new cards to firestore
                      break;
                    case 1:
                      image = Image.asset('assets/icons/visa.png');
                      text = Text('Thanh toán qua thẻ mới');
                      break;
                    case 2:
                      image = Image.asset('assets/icons/atm-card.png');
                      text = Text('Thanh toán qua thẻ hiện có');
                      break;
                  }

                  return InkWell(
                    onTap: () {
                      onItemPress(
                        context,
                        index,
                        "orderProvider.amount",
                        orderProvider,
                      );
                    },
                    child: ListTile(
                      title: text,
                      leading: image,
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(color: theme.primaryColor,),
                itemCount: 3),
          ),
        ],
      ),
    );
  }
}