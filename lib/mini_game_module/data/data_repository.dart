import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/player_model.dart';

class DataRepository {
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('players');
  final CollectionReference customer =
      FirebaseFirestore.instance.collection('Users');

  Future<void> addPlayer(Player player) {
    return collection.doc(player.uid).set(player.toJson());
  }

  updatePlayer(Player player) async {
    await collection.doc(player.uid).update(player.toJson());
  }

  Future<Player?> getPlayer(String uid) async {
    var doc = await collection.doc(uid).get();
    if (doc.data() == null) {
      return null;
    }
    return Player.fromJson(doc.data() as Map<dynamic, dynamic>);
  }

  Future<void> addRedeemPoint(int point) async {
    customer.doc(user?.uid).set(
      {'redeemPoint': FieldValue.increment(point)},
      SetOptions(merge: true),
    );
  }
}
