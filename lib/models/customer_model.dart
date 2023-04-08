import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  late String id;
  late String name;
  late String birthday;
  late String number;
  late String email;
  late String address;
  late String image;

  CustomerModel({required this.id, required this.name, required this.number, required this.email,required this.image,required this.address,required this.birthday});

  factory CustomerModel.fromDocument(DocumentSnapshot doc) {
    String email = "";
    String number = "";
    String address = "";
    String birthday = "";

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CustomerModel(
      id: doc.id,
      name:data['name'] as String,
      birthday: birthday,
      email: email,
      image: data['image'] as String,
      number: number,
      address: address);
  }
}


