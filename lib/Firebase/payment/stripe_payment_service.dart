import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
//import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({
    required this.message,
    required this.success});
}

class StripeService {

  CollectionReference cards= FirebaseFirestore.instance.collection('Cards');
  User? user = FirebaseAuth.instance.currentUser;

  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret = 'sk_test_51J8S4rHlo7l3MaI7yPmTCHQdeMn2uQozvoDs6Gj4MoqIaJvtKYMtsxZKZ5zkWMTtyQvJBGtkCC5fluXEnzCxGqKF00Td2Btmv8';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  /*static init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "pk_test_51J8S4rHlo7l3MaI7JpOJBPXFGgtVnpZE3iMwmjeQ3oRJREwdwz9OOw0L9HC7ha1CV1m9Wtgbxdjqlerr7PkuzPG200OqHpfsjI",
        merchantId: "Test",
        androidPayMode: 'test'
      )
    );
  }*/

  /*static Future<StripeTransactionResponse> payViaExistingCard({String amount, String currency, CreditCard card}) async{
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card)
      );
      var paymentIntent = await StripeService.createPaymentIntent(
        amount,
        currency
      );
      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id
        )
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
          message: 'Transaction successful',
          success: true
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transaction failed',
          success: false
        );
      }
    } on PlatformException catch(err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
        message: 'Transaction failed: ${err.toString()}',
        success: false
      );
    }
  }*/

  static Future<StripeTransactionResponse> payWithNewCard({String? amount, required String currency}) async {
    /*try {
      var paymentMethod = await FlutterStripePayment().paymentRequestWithCardForm(
        CardFormPaymentRequest()
      );
      var paymentIntent = await StripeService.createPaymentIntent(
        amount!,
        currency
      );
      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent!['client_secret'],
          paymentMethodId: paymentMethod.id
        )
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
          message: 'Transaction successful',
          success: true
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transaction failed',
          success: false
        );
      }
    } catch (err) {
      return new StripeTransactionResponse(
        message: 'Transaction failed: ${err.toString()}',
        success: false
      );
    }*/
    return new StripeTransactionResponse(
        message: 'Transaction failed: ',
        success: false
    );
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Đã xảy ra sự cố';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(
      message: message,
      success: false
    );
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse(StripeService.paymentApiUrl),
        body: body,
        headers: StripeService.headers
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }

  Future<void> saveCreditCard(Map<String, dynamic> values) async {
    await cards.add(values);
  }

  Future<void> deleteCreditCard(id) async {
    await cards.doc(id).delete();
  }

}