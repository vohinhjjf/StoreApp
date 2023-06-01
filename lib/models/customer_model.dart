import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  late String id;
  late String name;
  late String birthday;
  late String number;
  late String email;
  late String address;
  late String image;
  late List<dynamic> likeBkogs;
  late int point;
  late String checkin;
  late String luckyNumber;

  CustomerModel();

  factory CustomerModel.fromDocument(DocumentSnapshot doc) {
    CustomerModel customer = CustomerModel();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    customer.id = doc.id;
    customer.name = data['name'] as String;
    customer.birthday = data['birthday'] as String;
    customer.email = data['email'] as String;
    customer.image = data['image'] as String;
    customer.number = data['number'] as String;
    customer.address = data['address'] as String;
    customer.point = data['redeemPoint'] as int;
    customer.likeBkogs = data['likedBlogs'];
    customer.checkin = data['checkIn'] as String;
    customer.luckyNumber = data['luckyNumber'] as String;
    return customer;
  }
}
