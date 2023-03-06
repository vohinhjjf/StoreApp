import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class Office {
  late String id;
  late String address;
  late bool active;
  late double lat;
  late double lng;
  late String name;
  late double distance;

  Office({
    required this.id,
    required this.address,
    required this.active,
    required this.lat,
    required this.lng,
    required this.name,
  });

  factory Office.fromMap(QueryDocumentSnapshot<Map<String, dynamic>> json) => Office(
      id : json.id,
      address : json["address"],
      active : json["active"],
      lat : json['latitude'],
      lng : json["longitude"],
      name : json["name"],
  );
}
late Position currentPosition;

void setCurrentPosition(Position cur) {
  currentPosition = cur;
}

Future<List<Office>> getStores() async {
  var docSnapshot = await FirebaseFirestore.instance.collection('Location').get();
  List<Office> list = docSnapshot.docs.isNotEmpty
      ? docSnapshot.docs.map((e) => Office.fromMap(e)).toList()
      : [];
  return list;
}


