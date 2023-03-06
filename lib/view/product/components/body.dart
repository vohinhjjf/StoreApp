import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/utils/format.dart';
import 'package:store_app/view/product/product_detail_screen.dart';
import 'package:store_app/constant.dart';

class Body extends StatefulWidget {
  final List<CartModel> list_cartModel;
  Body(this.list_cartModel);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _updating = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 150),
      itemCount: widget.list_cartModel.length,
      itemBuilder: (context, index) {
        return productInfo(widget.list_cartModel[index]);
      },
    );
  }

  Widget productInfo(CartModel product) {
    var name = product.productName;

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      //margin: EdgeInsets.fromLTRB(5, space_height, 5, 0),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          setState(() {
            product.checkbuy = !product.checkbuy;
          });
        },
        child: Container(
          width: 300,
          height: 155,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Image.network(
                    product.productImage,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPrice(product),
                          Checkbox(
                              value: product.checkbuy,
                              onChanged: (value){
                                setState(() {
                                  product.checkbuy = value!;
                                  print(product.amount);
                                });
                              }
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 28,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _updating = true;
                                    });
                                    if (product.amount > 1) {
                                      setState(() {
                                        product.amount--;
                                      });
                                    }
                                  },
                                  child: Container(
                                    child: Icon(
                                      product.amount == 1 ? Icons.delete_outline : Icons.remove,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: double.infinity,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(vertical: BorderSide(color: Colors.grey)),
                                  ),
                                  child: Center(
                                      child: FittedBox(
                                          child: /*_updating ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                            ),
                                          ) : */Text(
                                            product.amount.toString(),
                                            style: const TextStyle(color: Colors.black),
                                          ))),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _updating = true;
                                      product.amount++;
                                    });
                                    print(product.productName);
                                  },
                                  child: Container(
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          TextButton(
                            child: const Text(
                              'Chi tiết',
                              style: TextStyle(
                                  fontSize: mFontListTile, color: mPrimaryColor),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              ProductModel productModel = ProductModel();
                              productModel.id = product.productId;
                              productModel.name = product.productName;
                              productModel.image = product.productImage;
                              productModel.price = product.price;
                              productModel.discountPercentage = product.discountPercentage;
                              productModel.category = product.category;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProductDetailScreen(productModel,id: prefs.getString('ID')!);
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]
          ),

        ),
      ),
    );
  }

  Column _buildPrice(CartModel product) => Column(
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
}
