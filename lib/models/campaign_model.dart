import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignModel {
  late String name;
  late String campaignId;
  late double discountPercentage;
  late double maxDiscount;
  late bool freeship;
  late int time;

  CampaignModel({
    this.name ='',
    this.campaignId='',
    this.maxDiscount=0,
    this.discountPercentage=0,
    this.freeship=true,
    this.time=0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'campaignId': campaignId,
      'discountPercentage': discountPercentage,
      "freeship":freeship,
      "maxDiscount":maxDiscount,
      "time": time
    };
  }
}

class CampaignViewModel {
  List<CampaignModel> getCampaign() {
    return [
      CampaignModel(
          name :'Voucher Freeship',
          campaignId:'1',
          maxDiscount:15,
          freeship: true,
          time: 3
      ),
      CampaignModel(
          name: "Giảm 15%",
          campaignId:'2',
          discountPercentage: 15,
          maxDiscount:30,
          freeship: false,
          time: 2
      ),
      CampaignModel(
          name: "Giảm 10%",
          campaignId:'3',
          discountPercentage: 10,
          maxDiscount:100,
          freeship: false,
          time: 3
      ),
      CampaignModel(
          name: "Giảm 8%",
          campaignId:'4',
          discountPercentage: 8,
          maxDiscount:100,
          freeship: false,
          time: 5
      ),
    ];
  }

  Object addVoucher() {
    var product = FirebaseFirestore.instance.collection('Voucher');
    // Call the user's CollectionReference to add a new user
    for (int i = 0; i < getCampaign().length; i++) {
      product.add(getCampaign()[i].toMap())
          .then((value) => print("Voucher Added"))
          .catchError((error) => print("Failed to add Voucher: $error"));
    }
    return 'null';
  }
}

class CollectionCoupon {
  bool active;
  String userId;
  String voucherId;

  CollectionCoupon({
    required this.active,
    required this.userId,
    required this.voucherId
  });

  factory CollectionCoupon.fromMap(DocumentSnapshot<Map<String, dynamic>> json) => CollectionCoupon(
    active: json['active'],
    userId: json['userId'],
    voucherId: json['voucherId'],
  );

  Map<String, dynamic> toMap() {
    return {
      'active': active
    };
  }
}


