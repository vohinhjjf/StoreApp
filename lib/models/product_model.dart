import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/models/product_model.dart';

class ProductModel {
  String id;
  bool freeship;
  bool hot;
  int discountPercentage;
  String image;
  String name;
  String details;
  String collection;
  String category;
  double price;
  int sold;
  int amount;
  bool checkBuy;

  ProductModel({
    this.id = '',
    this.freeship = false,
    this.hot = false,
    this.price = 0.0,
    this.discountPercentage = 0,
    this.name = "",
    this.image='',
    this.details = "Chưa có thông tin",
    this.collection = '',
    this.category= '',
    this.sold = 0,
    this.amount = 1,
    this.checkBuy = false
  });

  factory ProductModel.fromMap(QueryDocumentSnapshot<Map<String, dynamic>> json) => ProductModel(
      id: json.id,
      name: json['name'],
      image: json['image'],
      details: json['details'],
      collection: json['collection'],
      category: json['category'],
      price: json['price']*1.0,
      discountPercentage: json['discountPercentage'],
      sold: json['sold'],
      freeship: json['freeship'],
      hot: json['hot'],
      amount: json['amount'],
      checkBuy: json['checkBuy'],
  );

  factory ProductModel.toMap(QueryDocumentSnapshot json) => ProductModel(
    id: json.id,
    name: json['name'],
    image: json['image'],
    details: json['details'],
    collection: json['collection'],
    category: json['category'],
    price: json['price']*1.0,
    discountPercentage: json['discountPercentage'],
    sold: json['sold'],
    freeship: json['freeship'],
    hot: json['hot'],
    amount: json['amount'],
    checkBuy: json['checkBuy'],
  );

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'details': details,
      'collection': collection,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'sold' : sold,
      "freeship":freeship,
      "hot":hot,
      "amount":amount,
      "checkBuy":checkBuy,
    };
  }
}
Object addProduct(List<ProductModel> list) {
  var product = FirebaseFirestore.instance.collection('Products');
  // Call the user's CollectionReference to add a new user
  for (int i = 0; i < list.length; i++) {
    product.add(list[i].toMap())
        .then((value) => print("Product Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  return 'null';
}

