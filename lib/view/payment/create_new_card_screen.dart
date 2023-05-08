import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../Firebase/payment/stripe_payment_service.dart';
import '../../components/appbar.dart';

class CreateNewCreditCard extends StatefulWidget {
  static const String id ='create-card';
  @override
  State<StatefulWidget> createState() {
    return CreateNewCreditCardState();
  }
}

class CreateNewCreditCardState extends State<CreateNewCreditCard> {

  StripeService _stripeService = StripeService();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: ListAppBar().AppBarCart(
          context, "Thêm thẻ tín dụng",
              () => Navigator.of(context).pop()
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureInitialCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              isChipVisible: true,
              isSwipeGestureEnabled: false,
              animationDuration: Duration(milliseconds: 1000),
              glassmorphismConfig: Glassmorphism.defaultConfig(),
              backgroundNetworkImage: 'https://th.bing.com/th/id/OIP.dJegwPSS-s84fGCjn6F48AHaGL?pid=ImgDet&rs=1',
              onCreditCardWidgetChange: (CreditCardBrand ) {  },
              customCardTypeIcons: [
                CustomCardTypeIcon(
                  cardType: CardType.mastercard,
                  cardImage: Image.asset(
                    'assets/images/cancel.png',
                    height: 48,
                    width: 48,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumberDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Số thẻ',
                        hintText: 'XXXX XXXX XXXX XXXX',
                      ),
                      expiryDateDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ngày hết hạn',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Chủ thẻ',
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      themeColor: Colors.red,
                    ),

                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(const Color(0xff1b447b)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: const Text(
                          'Xác thực',
                          style: TextStyle(
                            color: Colors.white,
                            //fontFamily: 'halter',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            package: 'flutter_credit_card',
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          EasyLoading.show(status: 'Vui lòng đợi...');
                          _stripeService.saveCreditCard({
                            'cardNumber': cardNumber,
                            'expiryDate': expiryDate,
                            'cardHolderName': cardHolderName,
                            'cvvCode': cvvCode,
                            'showBackView': false,
                            'uid' : _stripeService.user!.uid
                          },).whenComplete(() {
                            EasyLoading.showSuccess('Lưu thành công thẻ...').then((value){
                              Navigator.pop(context);
                            });
                          });
                        }
                        else {
                          print('Không hợp lệ!');
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
