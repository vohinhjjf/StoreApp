import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/view/login/verification.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String ID ='';
  late String smsOtp;
  late String verificationId;
  String error = '';
  String address='';
  bool loading = false;
  late DocumentSnapshot snapshot;
  Repository repository = Repository();

  Future<void> verifyPhone({required BuildContext context, required String number}) async {
    this.loading = true;
    notifyListeners();

    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential) async {
      loading = false;
      notifyListeners();
      //await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      verificationId = verId;
      //Mở hộp thoại để nhập OTP SMS đã nhận
      Navigator.of(context).pushReplacement(
          MaterialPageRoute (
            builder: (BuildContext context) => Verificatoin(verificationId: verificationId, number: number,),
          )
      );
    };

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
        timeout: const Duration(seconds: 5),
      );
    } catch (e) {
      this.error = e.toString();
      this.loading = false;
      notifyListeners();
      print(e);
    }
  }


  void _createUser(String id, String number) {
    repository.createUserData(id,number);
    this.loading = false;
    notifyListeners();
  }

  void updateUser({String? id,String? number,String? email, required String birthday}) {
    repository.updateUserData(id,number,email,birthday, this.address);
    this.loading = false;
    notifyListeners();
  }

  getUserDetails()async {
    DocumentSnapshot result = await FirebaseFirestore.instance.collection('users').doc(
        _auth.currentUser!.uid).get();
    if(result !=null){
      this.snapshot = result;
      notifyListeners();
    }else{
      this.snapshot = null as DocumentSnapshot;
      notifyListeners();
    }
    return result;
  }

  Future<void> setPrefsID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ID', _auth.currentUser!.uid);
    print('Chưa xóa');
  }

  Future<void> deletePrefsID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ID', '');
    print('Đã xóa');
  }

  Future<bool> checkPrefsID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('ID'));
    return (prefs.getString('ID') == ''|| prefs.getString('ID') == null)? false : true;
  }

  addAvatar(PickedFile media) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (media != null) {
      final _avatar = File(media.path);
      if (_avatar != null) {
        final firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child(
            "user/${prefs.getString('ID')}/avatar"); //i is the name of the image
        UploadTask uploadTask =
        firebaseStorageRef.putFile(_avatar);
        //repository.updateAvatar(prefs.get('ID').toString(), url)
        TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);
        var downloadUrl = await storageSnapshot.ref.getDownloadURL();
        print('Url: $downloadUrl');
        repository.updateAvatar(prefs.get('ID').toString(), downloadUrl.toString());
      }
    }
  }
}

