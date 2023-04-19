import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel{
    String purchaseId;
   String productId;
   String productName;
   String productImage;
   double price;
   int discountPercentage;
   String category;
   int amount;
   bool checkbuy;
   bool reviewStatus;
   double total;

   CartModel({
     this.purchaseId = '',
     this.productId ='',
     this.productName ='',
     this.productImage ='',
     this.price=0,
     this.discountPercentage=0,
     this.category='',
     this.amount=0,
     this.checkbuy=false,
     this.reviewStatus=false,
     this.total=0
  });

   factory CartModel.fromMap(QueryDocumentSnapshot json) => CartModel(
     productId: json['productId'],
     productName: json['productName'],
     productImage: json['productImage'],
     price: json['price'],
     category: json['category'],
     discountPercentage: json['discountPercentage'],
     amount: json['amount'],
     checkbuy: json['checkbuy'],
     total: json['total'],
   );

   Map<String, dynamic> toMap() {
     return {
       "productId": productId,
       'productName': productName,
       'productImage': productImage,
       'price': price,
       'category': category,
       'discountPercentage': discountPercentage,
       "amount": amount,
       'reviewStatus': reviewStatus
     };
   }

    factory CartModel.fromMap2(QueryDocumentSnapshot json) => CartModel(
      purchaseId: json['purchaseId'],
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      price: json['price'],
      category: json['category'],
      discountPercentage: json['discountPercentage'],
      amount: json['amount'],
      reviewStatus: json['reviewStatus'],
    );

   Map<String, dynamic> toMap2(String id) {
     return {
       'purchaseId': id,
       "productId": productId,
       'productName': productName,
       'productImage': productImage,
       'price': price,
       'category': category,
       'discountPercentage': discountPercentage,
       "amount": amount,
       'reviewStatus': reviewStatus
     };
   }
}