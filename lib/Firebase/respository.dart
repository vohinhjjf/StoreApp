import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/models/address_model.dart';
import 'package:store_app/models/campaign_model.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/models/customer_model.dart';
import 'package:store_app/models/product_model.dart';

import 'firebase_realtime_data_service.dart';

class Repository {
  final customerApiProvider = CustomerApiProvider();

  Future<void> createUserData(String id, String number) =>
      customerApiProvider.createUserData({
        'id': id,
        'name': '',
        'number': number,
        'email': '',
        'birthday': '',
        'address': '',
        'image': '',
        'likedBlogs': [],
      });

  Future<void> updateAvatar(String id, String url) =>
      customerApiProvider.updateAvatar(id, url);

  Future<void> updateUserData(String? id, String? number, String? email,
          String birthday, String address) =>
      customerApiProvider.updateUserData({
        'id': id,
        'number': number,
        'email': email,
        'birthday': birthday,
        'address': address,
      });

  Future<CustomerModel> getUserById(String id) =>
      customerApiProvider.getUserById(id);

  Future<String> setAddress(AddressModel addressModel) =>
      customerApiProvider.setAddress(addressModel);

  Future<String> updateAddress(AddressModel addressModel) =>
      customerApiProvider.updateAddress(addressModel);

  Future<List<AddressModel>> getAddress() => customerApiProvider.getAddress();

  Future<AddressModel> selectAddressDefault() =>
      customerApiProvider.selectAddressDefault();

  Future<String> updateAddressDefault(String id) =>
      customerApiProvider.updateAddressDefault(id);

  Future<DocumentSnapshot> checkID(String id) =>
      customerApiProvider.checkID(id);

  Future<void> addToCart(ProductModel productModel) =>
      customerApiProvider.addToCart(productModel);

  Future<ProductModel> getCartId(String id_product) =>
      customerApiProvider.getCartId(id_product);

  Future<void> setAmount(String id, int amount) =>
      customerApiProvider.setAmountCart(id, amount);

  Future<void> setCheckBuy(String id, bool checkbuy) =>
      customerApiProvider.setCheckBuy(id, checkbuy);

  Future<void> setTotal(double total) => customerApiProvider.setTotal(total);

  Future<double> getTotal() => customerApiProvider.getTotal();

  Future<void> saveVoucher(String id) => customerApiProvider.saveVoucher(id);

  Future<List<CampaignModel>> getVoucherSaved() =>
      customerApiProvider.getVoucherSaved();

  Future<List<CollectionCoupon>> getActiveVoucher() =>
      customerApiProvider.getActiveVoucher();

  Future<void> setStores() => customerApiProvider.setStores();

  Future<bool> getCheckFreeShip() => customerApiProvider.getCheckFreeShip();

  Future<bool> getCheckVoucher() => customerApiProvider.getCheckFreeShip();

  Future<String> getFreeShip() => customerApiProvider.getFreeShip();

  Future<String> getDiscount() => customerApiProvider.getDiscount();

  Future<void> addPurchaseHistory(
          List<CartModel> list_product,
          AddressModel addressModel,
          double total,
          double discount,
          double freeship,
          bool checkFreeShip,
          bool checkVoucher) =>
      customerApiProvider.addPurchaseHistory(list_product, addressModel, total,
          discount, freeship, checkFreeShip, checkVoucher);

  Future<void> updateBlogViewCount(String id) =>
      customerApiProvider.updateBlogViewCount(id);

  Future<void> increaseBlogLikeCount(String id) =>
      customerApiProvider.increaseBlogLikeCount(id);

  Future<void> decreseBlogLikeCount(String id) =>
      customerApiProvider.decreaseBlogLikeCount(id);

  Query<Map<String, dynamic>> categoryFilter(int val) =>
      customerApiProvider.categoryFilter(val);

  Future<void> addBlogLiked(String blogId) =>
      customerApiProvider.addBlogLiked(blogId);

  Future<void> removeBlogLiked(String blogId) =>
      customerApiProvider.removeBlogLiked(blogId);

  Future<void> checkIfBlogIsLiked(String blogId, bool isPostLiked) =>
      customerApiProvider.checkIfBlogIsLiked(blogId, isPostLiked);

  Future<void> addComment(String blogId, var commentData) =>
      customerApiProvider.addComment(blogId, commentData);

  Future<void> removeComment(String blogId, var commentData) =>
      customerApiProvider.removeComment(blogId, commentData);

  Future<void> increaseCommentLikeCount(String blogId, var comment) =>
      customerApiProvider.increaseCommentLikeCount(blogId, comment);

  Future<void> addRedeemPoint(int point) =>
      customerApiProvider.addRedeemPoint(point);
  Future<void> exchangeVoucher(String id, int point) =>
      customerApiProvider.exchangeVoucher(id, point);
}
