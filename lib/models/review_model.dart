import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel{
  String productId;
  String detailedReview;
  List<dynamic> reviewImage;
  double rate;
  String time;

  ReviewModel({
    this.productId ='',
    this.detailedReview ='',
    required this.reviewImage,
    this.rate=0,
    this.time='',
  });

  factory ReviewModel.fromMap(QueryDocumentSnapshot json) => ReviewModel(
    productId: json['productId'],
    detailedReview: json['detailedReview'],
    reviewImage: json['reviewImage'],
    rate: json['rate'],
    time: json['time'],
  );

  Map<String, dynamic> toMap() {
    return {
      "productId": productId,
      'detailedReview': detailedReview,
      'reviewImage': reviewImage,
      'rate': rate,
      'time': time
    };
  }
}