import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier{

  late String status;
  late String amount;
  bool success = false;
  late String shopName;
  late String email;

  filterOrder(status){
    this.status =status;
    notifyListeners();
  }

  totalAmount(amount,shopName,email){
    this.amount = amount.toStringAsFixed(0);
    this.shopName = shopName;
    this.email = email;
    notifyListeners();
  }

  paymentStatus(success){
    this.success = success;
    notifyListeners();
  }
}