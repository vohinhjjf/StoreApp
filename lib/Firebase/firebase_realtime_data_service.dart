import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/models/address_model.dart';
import 'package:store_app/models/campaign_model.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/models/customer_model.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/models/sticker_model.dart';

import '../models/request_support_model.dart';
import '../models/review_model.dart';
import '../models/sticker_pack_model.dart';

class CustomerApiProvider {
  User? user = FirebaseAuth.instance.currentUser;
  var customer = FirebaseFirestore.instance.collection('Users');
  var product = FirebaseFirestore.instance.collection('Products');
  var cart = FirebaseFirestore.instance.collection('Cart');
  var voucher = FirebaseFirestore.instance.collection('Voucher');
  var banner = FirebaseFirestore.instance.collection('Banner');
  var blog = FirebaseFirestore.instance.collection('Blogs');
  var stickerPack = FirebaseFirestore.instance.collection('Sticker Packs');
  FirebaseStorage storage = FirebaseStorage.instance;

  //User
  //create new user
  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await customer.doc(id).set(values);
  }

  //update user data
  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await customer.doc(id).update(values);
  }

  //update avatar
  Future<void> updateAvatar(String id, String url) async {
    customer.doc(id).update({
      'image': url,
    });
  }

  //get user data by User id
  Future<CustomerModel> getUserById(String id) async {
    CustomerModel customerModel = CustomerModel();
    var docSnapshot = await customer.doc(user!.uid).get();
    if (docSnapshot.exists) {
      customerModel = CustomerModel.fromDocument(docSnapshot);
    }
    return customerModel;
  }

  Future<DocumentSnapshot> checkID(String id) async {
    var result = await customer.doc(id).get();
    return result;
  }

  Future<bool> checkFavorite(String productId) async {
    bool check = false;
    var docSnapshot =
        await customer.doc(user!.uid).collection('favorite').get();
    for (var id in docSnapshot.docs) {
      if (id.id == productId) {
        check = true;
      }
    }
    return check;
  }

  favoriteProduct(String productId) {
    customer.doc(user!.uid).collection('favorite').doc(productId).set({});
  }

  unfavoriteProduct(String productId) {
    customer.doc(user!.uid).collection('favorite').doc(productId).delete();
  }

  Future<List<ProductModel>> getListFavorite() async {
    List<ProductModel> list_product = [];
    var docSnapshot =
        await customer.doc(user!.uid).collection('favorite').get();
    for (var id in docSnapshot.docs) {
      await getCartId(id.id).then((value) => list_product.add(value));
    }
    return list_product;
  }

  //Address
  Future<String> setAddress(AddressModel addressModel) async {
    return customer
        .doc(user!.uid)
        .collection('address')
        .add(addressModel.toMap())
        .toString();
  }

  Future<String> updateAddress(AddressModel addressModel) async {
    return await customer
        .doc(user!.uid)
        .collection('address')
        .doc(addressModel.id)
        .update(addressModel.toMap())
        .toString();
  }

  Future<List<AddressModel>> getAddress() async {
    var docSnapshot = await customer.doc(user!.uid).collection('address').get();
    List<AddressModel> list = docSnapshot.docs.isNotEmpty
        ? docSnapshot.docs.map((e) => AddressModel.fromMap(e)).toList()
        : [];
    return list;
  }

  Future<AddressModel> selectAddressDefault() async {
    var docSnapshot = await customer
        .doc(user!.uid)
        .collection('address')
        .where('mac_dinh', isEqualTo: true)
        .get();
    AddressModel addressModel =
        docSnapshot.docs.map((e) => AddressModel.fromMap(e)).first;
    return addressModel;
  }

  Future<String> updateAddressDefault(String id, int length) async {
    if(length > 1) {
      await selectAddressDefault().then((value) async {
        await customer
            .doc(user!.uid)
            .collection('address')
            .doc(value.id)
            .update({"mac_dinh": false});
      });
    }
    var result = await customer
        .doc(user!.uid)
        .collection('address')
        .doc(id)
        .update({"mac_dinh": true}).toString();
    return result;
  }

  //Product
  Future<void> addToCart(ProductModel productModel) async {
    bool check = false;
    await cart.doc(user!.uid).collection('products').get().then((value) async {
      if (value.docs.isNotEmpty) {
        for (DocumentSnapshot ds in value.docs) {
          if (ds["productId"] == productModel.id) {
            cart.doc(user!.uid).collection('products').doc(ds.id).update({
              "amount": ds["amount"] + 1,
            });
            check = true;
            print("1");
          }
        }
        if (!check) {
          print("2");
          await cart.doc(user!.uid).collection('products').add({
            'productId': productModel.id,
            'productName': productModel.name,
            'productImage': productModel.image,
            'price': productModel.price,
            'discountPercentage': productModel.discountPercentage,
            'category': productModel.category,
            'amount': productModel.amount,
            'checkbuy': productModel.checkBuy,
            'total': productModel.amount * productModel.price,
          });
        }
      } else {
        print("3");
        /*await cart.doc(user!.uid).set({
          "total": productModel.amount*productModel.price
        });*/
        await cart.doc(user!.uid).collection('products').add({
          'productId': productModel.id,
          'productName': productModel.name,
          'productImage': productModel.image,
          'price': productModel.price,
          'discountPercentage': productModel.discountPercentage,
          'category': productModel.category,
          'amount': productModel.amount,
          'checkbuy': productModel.checkBuy,
          'total': productModel.amount * productModel.price,
        });
      }
    });
  }

  Future<ProductModel> getCartId(String id_product) async {
    ProductModel _product = ProductModel();
    var docSnapshot = await product.doc(id_product).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      _product = ProductModel(
        id: docSnapshot.id,
        name: data['name'],
        image: data['image'],
        details: data['details'],
        collection: data['collection'],
        category: data['category'],
        price: data['price'] * 1.0,
        discountPercentage: data['discountPercentage'],
        sold: data['sold'],
        freeship: data['freeship'],
        hot: data['hot'],
        amount: data['amount'],
        checkBuy: data['checkBuy'],
      );
    }
    ;
    return _product;
  }

  Future<void> setAmountCart(String id, int amount) async {
    var snapshot = await cart
        .doc(user!.uid)
        .collection('products')
        .where('productId', isEqualTo: id)
        .get();
    return cart
        .doc(user!.uid)
        .collection('products')
        .doc(snapshot.docs.first.id)
        .update({'amount': amount});
  }

  Future<void> setCheckBuy(String id, bool checkbuy) async {
    var snapshot = await cart
        .doc(user!.uid)
        .collection('products')
        .where('productId', isEqualTo: id)
        .get();
    return cart
        .doc(user!.uid)
        .collection('products')
        .doc(snapshot.docs.first.id)
        .update({'checkbuy': checkbuy});
  }

  Future<void> setTotal(double total) {
    return cart.doc(user!.uid).set({'total': total});
  }

  Future<double> getTotal() async {
    var snapshot = await cart.doc(user!.uid).get();
    return snapshot.data()!['total'];
  }

  Future<List<ProductModel>> search(String searchKey) async {
    List<ProductModel> list_1 = [];
    List<ProductModel> list_2 = [];
    await product
        .where("name", isGreaterThanOrEqualTo: "Laptop")
        .get()
        .then((value) {
      list_1 = value.docs.map((e) => ProductModel.fromMap(e)).toList();
    });
    for (int i = 0; i < list_1.length; i++) {
      if (list_1[i].name.toLowerCase().contains(searchKey)) {
        list_2.add(list_1[i]);
      }
    }
    return list_2;
  }

  //Voucher
  Future<void> saveVoucher(String id) async {
    return voucher
        .doc(id)
        .collection('collection')
        .doc(user!.uid)
        .set({'active': false, 'voucherId': id, 'userId': user!.uid});
  }

  Future<void> exchangeVoucher(String id, int point) async {
    exchangeRedeemPoint(point, id);
  }

  Future<List<CampaignModel>> getVoucherSaved() async {
    List<String> listId = [];
    List<CampaignModel> listVoucher = [];
    await voucher
        .get()
        .then((value) => {listId = value.docs.map((e) => e.id).toList()});
    for (int i = 0; i < listId.length; i++) {
      await voucher
          .doc(listId[i])
          .collection('collection')
          .doc(user!.uid)
          .get()
          .then((value) async {
        if (value.data() != null) {
          await voucher.doc(listId[i]).get().then((value) => {
                if (value.data()!['active'])
                  {
                    listVoucher.add(CampaignModel(
                      campaignId: listId[i],
                      name: value.data()!['name'],
                      discountPercentage:
                          value.data()!['discountPercentage'] * 1.0,
                      maxDiscount: value.data()!['maxDiscount'] * 1.0,
                      freeship: value.data()!['freeship'],
                      time: value.data()!['time'],
                    ))
                  }
              });
        }
      });
    }
    print(listVoucher.map((e) => e.name));
    return listVoucher;
  }

  Future<List<CollectionCoupon>> getActiveVoucher() async {
    List<String> listId = [];
    List<CollectionCoupon> listActive = [];
    await voucher
        .get()
        .then((value) => {listId = value.docs.map((e) => e.id).toList()});
    for (int i = 0; i < listId.length; i++) {
      await voucher
          .doc(listId[i])
          .collection('collection')
          .doc(user!.uid)
          .get()
          .then((value) async {
        if (value.exists) {
          listActive.add(CollectionCoupon.fromMap(value));
        }
      });
    }
    return listActive;
  }

  Future<bool> checkVoucher(String id) async {
    List<String> listId = [];
    await voucher
        .doc(id)
        .collection('collection')
        .get()
        .then((value) => {listId = value.docs.map((e) => e.id).toList()});
    print(listId.length);
    for (int i = 0; i < listId.length; i++) {
      if (listId[i] == user!.uid) {
        return true;
      }
      print(listId[i]);
    }
    return false;
  }

  //Request Support
  Future<void> requestSupport(
      RequestSupportModel requestSupportModel, PickedFile media) async {
    var _value, downloadUrl;
    if (media != null) {
      final _image = File(media.path);
      if (_image != null) {
        final firebaseStorageRef = FirebaseStorage.instance.ref().child(
            "user/${user!.uid}/requestSupport/${DateTime.now()}"); //i is the name of the image
        UploadTask uploadTask = firebaseStorageRef.putFile(_image);
        //repository.updateAvatar(prefs.get('ID').toString(), url)
        TaskSnapshot storageSnapshot =
            await uploadTask.whenComplete(() => null);
        downloadUrl = await storageSnapshot.ref.getDownloadURL();
      }
    }
    final data = {
      'senderId': user?.uid,
      'senderName': requestSupportModel.senderName,
      'problemType': requestSupportModel.problemType,
      'description': requestSupportModel.description,
      'isActive': requestSupportModel.isActive ? "true" : "false",
      'photo': downloadUrl.toString(),
      'timestamp': DateTime.now().toIso8601String()
    };
    FirebaseFirestore.instance
        .collection('Request Support')
        .add(data)
        .then((value) => {_value = 1, print("Request Support add")})
        .catchError((error) =>
            {_value = 0, print("Failed to add Request Support: $error")});
    print(_value);
  }

  //Location
  Future<void> setStores() async {
    final data_store = {
      "offices 0": {
        "address":
            "109 Đường Nguyễn Duy Trinh, Phường Bình Trưng Tây, Quận 2, Thành phố Hồ Chí Minh",
        "id": "00",
        "lat": 10.7883213,
        "lng": 106.7582736,
        "name": "Cửa hàng số 0"
      },
      "offices 1": {
        "address":
            "447 Đường Phan Văn Trị, Phường 5, Quận Gò Vấp, Thành phố Hồ Chí Minh",
        "id": "01",
        "lat": 10.8222785,
        "lng": 106.6929956,
        "name": "Cửa hàng số 1"
      },
      "offices 2": {
        "address":
            "119/7/1 Đường số 7, Phường 3, Quận Gò Vấp, Thành phố Hồ Chí Minh",
        "id": "02",
        "lat": 10.8113253,
        "lng": 106.6817612,
        "name": "Cửa hàng số 2"
      }
    };
    return FirebaseFirestore.instance
        .collection('Location')
        .doc('store')
        .set(data_store)
        .then((value) => print("Store Added"))
        .catchError((error) => print("Failed to add store: $error"));
  }

  //Payment
  Future<bool> getCheckFreeShip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("checkFreeShip")!;
  }

  Future<bool> getCheckVoucher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("checkVoucher")!;
  }

  Future<String> getFreeShip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("Freeship")!;
  }

  Future<String> getDiscount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("Discount")!;
  }

  //purchase history
  Future<void> addPurchaseHistory(
      List<CartModel> list_product,
      AddressModel addressModel,
      double total,
      double discount,
      double freeship,
      bool checkFreeShip,
      bool checkVoucher) async {
    await customer.doc(user!.uid).collection('purchase history').add({
      "orderStatus": "Đang xử lý",
      "orderDate": DateFormat("HH:mm:ss dd/MM/yyyy").format(DateTime.now()),
      "nameRecipient": addressModel.ten,
      "phoneRecipient": addressModel.so_dien_thoai,
      "addressRecipient":
          "${addressModel.dia_chi}, ${addressModel.xa}, ${addressModel.huyen}, ${addressModel.tinh}",
      //"products":list_product.map((e) => e.toMap()).toList(),
      "discount": discount,
      "freeship": freeship,
      "checkFreeShip": checkFreeShip,
      "checkVoucher": checkVoucher,
      "total": total
    }).then((value) async {
      for (int i = 0; i < list_product.length; i++) {
        await customer
            .doc(user!.uid)
            .collection('purchase history')
            .doc(value.id)
            .collection("products")
            .doc(list_product[i].productId)
            .set(list_product[i].toMap2(value.id));
      }
      deleteCart();
    });
  }

  Future<void> deleteCart() async {
    await cart
        .doc(user!.uid)
        .collection('products')
        .where("checkbuy", isEqualTo: true)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    await cart.doc(user!.uid).update({"total": 0.0});
  }

  Future<void> statusOrder(String orderId, String status) async {
    await customer
        .doc(user!.uid)
        .collection('purchase history')
        .doc(orderId)
        .update({"orderStatus": status});
  }

  Future<void> addSold(List<dynamic> list) async {
    for(var doc in list) {
      product.doc(doc['productId']).set(
        {'sold': FieldValue.increment(doc['amount'])},
        SetOptions(merge: true),
      );
    }
  }

  //review
  Future<String> uploadImageVideo(XFile media, int temp, String time) async {
    var downloadUrl;
    if (media != null) {
      final _image = File(media.path);
      if (_image != null) {
        final firebaseStorageRef = FirebaseStorage.instance.ref().child(
            "user/${user!.uid}/review/$time/$temp"); //i is the name of the image
        UploadTask uploadTask = firebaseStorageRef.putFile(_image);
        //repository.updateAvatar(prefs.get('ID').toString(), url)
        TaskSnapshot storageSnapshot =
            await uploadTask.whenComplete(() => null);
        downloadUrl = await storageSnapshot.ref.getDownloadURL();
      }
    }
    return downloadUrl;
  }

  Future<void> addReview(ReviewModel reviewModel, String id) async {
    await customer.doc(user!.uid).collection('review').add(reviewModel.toMap());
    await product.doc(reviewModel.productId).collection('review').add({
      "userId": user!.uid,
      'detailedReview': reviewModel.detailedReview,
      'reviewImage': reviewModel.reviewImage,
      'rate': reviewModel.rate,
      'time': reviewModel.time
    });
    await customer
        .doc(user!.uid)
        .collection('purchase history')
        .doc(id)
        .collection('products')
        .doc(reviewModel.productId)
        .update({"reviewStatus": true});
  }

  Future<List<ReviewModel>> getListReviewed() async {
    var docSnapshot = await customer.doc(user!.uid).collection('review').get();
    List<ReviewModel> listReview = docSnapshot.docs.isNotEmpty
        ? docSnapshot.docs.map((e) => ReviewModel.fromMap(e)).toList()
        : [];
    return listReview;
  }

  Future<void> updateBlogViewCount(String id) async {
    blog.doc(id).set(
      {'views': FieldValue.increment(1)},
      SetOptions(merge: true),
    );
    print(id);
  }

  Future<void> increaseBlogLikeCount(String id) async {
    blog.doc(id).set(
      {'likes': FieldValue.increment(1)},
      SetOptions(merge: true),
    );
  }

  Future<void> decreaseBlogLikeCount(String id) async {
    blog.doc(id).set(
      {'likes': FieldValue.increment(-1)},
      SetOptions(merge: true),
    );
  }

  Future<void> addBlogLiked(String blogId) async {
    customer.doc(user?.uid).update({
      "likedBlogs": FieldValue.arrayUnion([blogId]),
    });
  }

  Future<void> removeBlogLiked(String blogId) async {
    customer.doc(user?.uid).update({
      "likedBlogs": FieldValue.arrayRemove([blogId]),
    });
  }

  Future<void> checkIfBlogIsLiked(String blogId, bool isPostLiked) async {
    var doc = customer.doc(user?.uid).get();
    var data = await doc;
    if (data.data()!["likedBlogs"].contains(blogId)) {
      isPostLiked = true;
    } else {
      isPostLiked = false;
    }
  }

  Future<void> addComment(String blogId, var commentData) async {
    blog.doc(blogId).update(
      {
        "comments": FieldValue.arrayUnion([commentData])
      },
    );
  }

  Future<void> removeComment(String blogId, var commentData) async {
    blog.doc(blogId).update(
      {
        "comments": FieldValue.arrayRemove([commentData])
      },
    );
  }

  Future<void> increaseCommentLikeCount(String blogId, var comment) async {
    final dummy = comment;
    removeComment(blogId, comment);
    dummy['likes'] = dummy['likes'] + 1;
    blog.doc(blogId).update(
      {
        'comments': FieldValue.arrayUnion([dummy])
      },
    );
  }

  Query<Map<String, dynamic>> categoryFilter(int val) {
    switch (val) {
      case 0:
        {
          return blog.where('active', isEqualTo: true);
        }
      case 1:
        {
          return blog
              .where('category', isEqualTo: 'Đồ công nghệ')
              .where('active', isEqualTo: true);
        }
      case 2:
        {
          return blog
              .where('category', isEqualTo: 'Game')
              .where('active', isEqualTo: true);
        }

      case 3:
        {
          return blog
              .where('category', isEqualTo: 'Thủ thuật - Hướng dẫn')
              .where('active', isEqualTo: true);
        }
      case 4:
        {
          return blog
              .where('category', isEqualTo: 'Giải trí')
              .where('active', isEqualTo: true);
        }
      case 5:
        {
          return blog
              .where('category', isEqualTo: 'Coding')
              .where('active', isEqualTo: true);
        }
      default:
        {
          return blog.where('active', isEqualTo: true);
        }
    }
  }

  // Point
  Future<void> addRedeemPoint(int point) async {
    customer.doc(user?.uid).set(
      {'redeemPoint': FieldValue.increment(point)},
      SetOptions(merge: true),
    );
  }

  Future<void> exchangeRedeemPoint(int point, String id) async {
    customer.doc(user?.uid).get().then((value) {
      if (point <= value['redeemPoint']) {
        customer.doc(user?.uid).set(
          {'redeemPoint': FieldValue.increment(-point)},
          SetOptions(merge: true),
        );
        saveVoucher(id);
      }
    });
  }

  Future<void> checkInPoint(int point) async {
    customer.doc(user?.uid).set(
      {
        'redeemPoint': FieldValue.increment(point),
        'checkIn':
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"
      },
      SetOptions(merge: true),
    );
  }

  Future<void> luckyNumber(String number) async {
    customer.doc(user?.uid).set(
      {'luckyNumber': number},
      SetOptions(merge: true),
    );
  }

  Future<List<StickerPackModel>> getSticker() async {
    var docSnapshot =
        await customer.doc(user!.uid).collection('Sticker Packs').get();
    List<StickerPackModel> list = docSnapshot.docs.isNotEmpty
        ? docSnapshot.docs.map((e) => StickerPackModel.fromMap(e)).toList()
        : [];
    return list;
  }

  Future<bool> checkSticker(String id) async {
    var docSnapshot =
        await customer.doc(user!.uid).collection('StickerPacks').get();
    List<String> list = docSnapshot.docs.isNotEmpty
        ? docSnapshot.docs.map((e) => e.id).toList()
        : [];
    print(list[0] + id);
    if (list.contains(id)) {
      print('FUCKKKKKKKKKKKKKKKKKKKKKKKKKKKKK');
      return true;
    } else {
      return false;
    }
  }

  Future<List<String>> getUserSticker() async {
    List<String> listUserSticker = [];
    List<String> listActive = [];
    await customer.doc(user!.uid).collection('StickerPacks').get().then(
        (value) => {listUserSticker = value.docs.map((e) => e.id).toList()});

    for (int i = 0; i < listUserSticker.length; i++) {
      await stickerPack
          .doc(listUserSticker[i])
          .collection('Stickers')
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          List<String> listTemp =
              value.docs.map((e) => e['image'].toString()).toList();
          listActive.addAll(listTemp);
        }
      });
    }
    return listActive;
  }

  Future<void> addSticker(String id) async {
    customer.doc(user!.uid).collection('StickerPacks').doc(id).set({'id': id});
  }
}
