import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/components/appbar.dart';
import 'package:store_app/components/image_slider.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/view/card/widgets/product_load_more.dart';

class ProductListWidget extends StatefulWidget {
  final String select;
  final String title;
  final String id;
  const ProductListWidget(this.select, this.title, this.id);
  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  final customerApiProvider = CustomerApiProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ListAppBar().AppBarListProduct(context, widget.title, widget.id),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSlider(),
            const SizedBox(height: 10,),
            _buildDivider(),
            StreamBuilder(
                stream: customerApiProvider.product.where('category', isEqualTo: widget.select)
                    .where("active", isEqualTo: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasData){
                    List<ProductModel> list = snapshot.data!.docs.isNotEmpty
                        ? snapshot.data!.docs.map((e) => ProductModel.toMap(e)).toList()
                        : [];
                    return ProductLoadMore(list,widget.title);
                  }
                  else if(snapshot.hasError) {
                    print('Lỗi: ${snapshot.error}');
                    return Container();
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() => Container(
    height: 5,
    color: Colors.grey[200],
  );
}