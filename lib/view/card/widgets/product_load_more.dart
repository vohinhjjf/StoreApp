import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/utils/format.dart';
import 'package:store_app/view/product/product_detail_screen.dart';

class ProductLoadMore extends StatefulWidget {
  final List<ProductModel> _productViewModel;
  final String id;
  const ProductLoadMore(this._productViewModel, this.id);

  @override
  _ProductLoadMoreState createState() => _ProductLoadMoreState();
}

class _ProductLoadMoreState extends State<ProductLoadMore> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          _buildProductList(),
        ],
      ),
    );
  }

  Container _buildHeader() => Container(
    //color: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
    child: Text(
      widget.id,
      style: TextStyle(
        color: widget.id == 'Sản Phẩm Nổi Bật'? Colors.deepOrange : Colors.black,
        fontSize: mFontTitle,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Column _buildProductList() => Column(
    children: [
      GridView.builder(
        padding: const EdgeInsets.all(3),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget._productViewModel.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.6,
          crossAxisCount: 2,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ProductItemCard(widget._productViewModel[index]);
        },
      ),
      false ? const SizedBox(height: 150) : BottomLoader(),
    ],
  );

}

class ProductItemCard extends StatelessWidget {
  final ProductModel product;

  const ProductItemCard(this.product);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          shadowColor: Colors.grey,
          elevation: 6,
          margin: EdgeInsets.zero,
          child: Container(
            height: 20,
            decoration: ShapeDecoration(
                color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              )
            ),
            child: GestureDetector(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProductDetailScreen(product,id: prefs.getString('ID') ?? "");
                      },
                    ),
                  );
                },
                child: Column(
                  children: [
                    _buildProductImage(constraints.maxHeight),
                    _buildProductInfo(),
                  ],
                )
            ),
          ),
        );
      },
    );
  }

  Stack _buildProductImage(double maxHeight) {
    return Stack(
      children: <Widget>[
        Image.network(
          product.image,
          height: maxHeight - 96,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        Row(
          children: [
            if (product.hot) _buildHot(),
            if (product.freeship) _buildFreeship(),
          ],
        )
      ],
    );
  }

  Container _buildHot() => Container(
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      color: const Color(0xffd0011b),
      borderRadius: BorderRadius.circular(2),
    ),
    child: const Text(
      "Hot",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    ),
  );

  Container _buildFreeship() => Container(
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(2),
    ),
    child: const Text(
      "FREESHIP",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    ),
  );

  Container _buildProductInfo() => Container(
        height: 96,
        //color: Colors.lightBlueAccent,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween ,
          children: [
            _buildName(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPrice(),
                _buildSold(),
              ],
            ),
            product.discountPercentage != 0? Row(
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
            ) : const SizedBox(height: 10,),
          ],
        ),
      );

  Text _buildName() => Text(
        product.name,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );

  RichText _buildPrice() => RichText(
        text: TextSpan(
          text: '${Format().currency(product.price*(100-product.discountPercentage)/100, decimal: false).replaceAll(RegExp(r','), '.')}đ',

          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
      );

  Text _buildSold() => Text(
        "đã bán ${product.sold}",
        style: const TextStyle(
          fontSize: 10,
        ),
      );
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 22),
      width: double.infinity,
      alignment: Alignment.center,
      child: const Center(
        child: Text(
          "Đang tải",
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
