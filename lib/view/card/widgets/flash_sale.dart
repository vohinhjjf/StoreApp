import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/components/discount_painter.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/utils/format.dart';
import 'package:store_app/view/product/list_product_sale.dart';
import 'package:store_app/view/product/product_detail_screen.dart';

class FlashSale extends StatelessWidget {
  final List<ProductModel> _flashSaleViewModel;
  const FlashSale(this._flashSaleViewModel);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(_flashSaleViewModel),
        FlashSaleList(_flashSaleViewModel),
      ],
    );
  }
}


class Header extends StatelessWidget {
  final List<ProductModel> _flashSaleViewModel;
  const Header(this._flashSaleViewModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      padding: const EdgeInsets.only(left: 5),
      //color: Colors.white,
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              "assets/images/hotsale.png",
              width: 35,
              height: 35,
            ),
          ),
          const Text('Khuyến Mãi Hot',
            style: TextStyle(
              fontSize: mFontTitle,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          Spacer(),
          MaterialButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              Navigator.of(context).push(MaterialPageRoute (
                builder: (BuildContext context) =>  ListSaleWidget(id: prefs.getString('ID')!),
              ));
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: const Text(
              "Xem thêm >",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FlashSaleList extends StatelessWidget {
  final List<ProductModel> _flashSaleViewModel;
  const FlashSaleList(this._flashSaleViewModel);
  @override
  Widget build(BuildContext context) {
    int count = _flashSaleViewModel.length >4 ? 6: _flashSaleViewModel.length+ 1;
    return Container(
      height: 240.0,
      //color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.separated(
        //padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: count,
        itemBuilder: (BuildContext context, int index) {
          if (index == count-1) {
            return _buildMore();
          }

          final flashSale = _flashSaleViewModel[index];
          return FlashSaleItem(flashSale);
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 8),
      ),
    );
  }

  GestureDetector _buildMore() {
    final Color color = Colors.deepOrange;
    return GestureDetector(
      onTap: (){
        print("xem tất cả");
      },
      child: SizedBox(
        width: 150,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 45.0,
              height: 45.0,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                border: Border.all(
                  color: color,
                  width: 2.5,
                ),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: color,
              ),
            ),
            Text(
              "Xem tất cả",
              style: TextStyle(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlashSaleItem extends StatelessWidget {
  final ProductModel flashSale;

  const FlashSaleItem(this.flashSale);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.deepOrange,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        width: 175,
        child: GestureDetector(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ProductDetailScreen(flashSale,id: prefs.getString('ID')==null?"id":prefs.getString('ID')!);
                },
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _buildProductImage(),
                  if (flashSale.discountPercentage != 0) _buildDiscount(),
                  if (flashSale.hot) _buildMall(),
                ],
              ),
              _buildName(),
              const SizedBox(height: 8,),
              _buildPrice(),
            ],
          ),
        ),
      ),
    );
  }

  Image _buildProductImage() => Image.network(
        flashSale.image,
        height: 170,
        width: 170,
      );

  Align _buildDiscount() => Align(
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
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "${flashSale.discountPercentage}%",
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Container _buildMall() => Container(
        height: 25,
        width: 40,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xffd0011b),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text(
          "Hot",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      );

  Padding _buildPrice() => Padding(
        padding: EdgeInsets.only(left: 5),
        child: Text(
          '${Format().currency(flashSale.price, decimal: false).replaceAll(RegExp(r','), '.')}đ',
          style: const TextStyle(
            color: Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
  Padding _buildName() => Padding(
      padding: EdgeInsets.only(left: 5),
      child: Text(
        flashSale.name,
        style: TextStyle(
            fontWeight: FontWeight.w500
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
  );
}
