import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/components/appbar.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/view/product/product_detail_screen.dart';

import '../../Firebase/firebase_realtime_data_service.dart';
import '../../components/discount_painter.dart';
import '../../utils/format.dart';

class ListFavoriteWidget extends StatefulWidget {
  ListFavoriteWidget({super.key});
  @override
  _ListFavoriteWidgetState createState() => _ListFavoriteWidgetState();
}

class _ListFavoriteWidgetState extends State<ListFavoriteWidget> {
  final customerApiProvider = CustomerApiProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ListAppBar().AppBarCart(context, "Sản phẩm yêu thích", (){
        Navigator.of(context).pop();
      }),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: StreamBuilder(
            stream: customerApiProvider.getListFavorite().asStream(),
            builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
              if(snapshot.hasData){
                return BuildList(snapshot.data!);
              }
              else if(snapshot.hasError) {
                print('Lỗi: ${snapshot.error}');
                return Container();
              }
              return const Center(child: CircularProgressIndicator());
            }
        ),
      ),
    );
  }

  BuildList(List<ProductModel> list_cartModel){
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 80,top: 15),
      itemCount: list_cartModel.length,
      itemBuilder: (context, index) {
        return productInfo(list_cartModel[index]);
      },
    );
  }

  Widget productInfo(ProductModel product) {
    var name = product.name;
    return Card(
      shadowColor: Colors.grey,
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      //margin: EdgeInsets.fromLTRB(5, space_height, 5, 0),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ProductDetailScreen(product,(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ListFavoriteWidget();
                      },
                    ),
                  );
                },id: prefs.getString('ID')!);
              },
            ),
          );
        },
        child: Container(
          width: 300,
          height: 155,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      Image.network(
                          product.image
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 160,
                          width: 38,
                          child: CustomPaint(
                            painter: DiscountPainter(),
                            size: const Size(30, 180),
                            child: Column(
                              children: [
                                const SizedBox(height: 3),
                                const Text(
                                  "Giảm",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "${product.discountPercentage}%",
                                  style: const TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5,),
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                        const TextStyle(fontSize: mFontListTile, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10,),
                      _buildPrice(product),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                              color: Colors.deepOrange,
                              onPressed: () {
                                customerApiProvider.addToCart(product).then((value) {
                                  setState(() {
                                    Dialog(context);
                                  });
                                });
                              },
                              child: const Text(
                                'Thêm vào giỏ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ]
          ),

        ),
      ),
    );
  }

  Column _buildPrice(ProductModel product) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: '${Format().currency(product.price*(100-product.discountPercentage)/100, decimal: false).replaceAll(RegExp(r','), '.')}đ',
          /*'${MoneyFormatter(
              amount: product.price*(100-product.discountPercentage)/100
          ).output.withoutFractionDigits}đ',*/
          style: const TextStyle(
              fontSize: 16,
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      if (product.discountPercentage != 0) Row(
        children: [
          Text(
            '${Format().currency(product.price, decimal: false).replaceAll(RegExp(r','), '.')}đ',
            softWrap: true,
            style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough
            ),
          ),
          const SizedBox(width: 5,),
          Text(
            "${product.discountPercentage}%",
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ],
  );

  Dialog(BuildContext context) {
    late Timer _timer;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          _timer = Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.5),
            title: Column(
              children: const [
                Icon(
                  MdiIcons.checkboxMarkedCircle,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Đã thêm vào giỏ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }).then((val){
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }
}