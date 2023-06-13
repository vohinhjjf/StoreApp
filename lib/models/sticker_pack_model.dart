import 'package:cloud_firestore/cloud_firestore.dart';

class StickerPackModel {
  String id;
  String name;
  String image;
  int redeemPoint;

  StickerPackModel({
    required this.id,
    required this.name,
    required this.image,
    required this.redeemPoint,
  });

  factory StickerPackModel.fromMap(QueryDocumentSnapshot json) =>
      StickerPackModel(
        id: json.id,
        name: json['name'],
        image: json['thumbnail'],
        redeemPoint: json['redeemPoint'],
      );

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'redeemPoint': redeemPoint,
    };
  }
}
