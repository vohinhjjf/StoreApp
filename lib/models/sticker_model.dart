import 'package:cloud_firestore/cloud_firestore.dart';

class StickerModel {
  String id;
  String name;
  String image;

  StickerModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory StickerModel.fromMap(QueryDocumentSnapshot json) => StickerModel(
        id: json.id,
        name: json['name'],
        image: json['image'],
      );

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }
}
