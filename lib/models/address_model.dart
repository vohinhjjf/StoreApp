import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  String id;
  String ten;
  String so_dien_thoai;
  String tinh;
  String huyen;
  String xa;
  String dia_chi;
  String loai_dia_chi;
  bool mac_dinh;

  AddressModel({
    required this.id,
    required this.ten,
    required this.so_dien_thoai,
    required this.tinh,
    required this.huyen,
    required this.xa,
    required this.dia_chi,
    required this.loai_dia_chi,
    required this.mac_dinh,
  });

  factory AddressModel.fromMap(QueryDocumentSnapshot json) => AddressModel(
    id: json.id,
    ten: json['name'],
    so_dien_thoai: json['number'],
    tinh: json['tinh'],
    huyen: json['huyen'],
    xa: json['xa'],
    dia_chi: json['address'],
    loai_dia_chi: json['loai_dia_chi'],
    mac_dinh: json['mac_dinh'],
  );

  Map<String, dynamic> toMap() {
    return {
      'name': ten,
      'number': so_dien_thoai,
      'tinh': tinh,
      "huyen":huyen,
      "xa":xa,
      "address": dia_chi,
      "loai_dia_chi":loai_dia_chi,
      "mac_dinh":mac_dinh,
    };
  }
}