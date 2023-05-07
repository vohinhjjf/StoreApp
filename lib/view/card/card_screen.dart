import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/components/appbar.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/view/card/widgets/flash_sale.dart';
import 'package:store_app/view/card/widgets/product_load_more.dart';
import 'package:store_app/view/card/widgets/search.dart';
import 'package:store_app/view/product/product_list_screen.dart';


class CardScreen extends StatefulWidget {
  String id ="id";
  CardScreen({super.key, required this.id});
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ListAppBar().AppBarHome(context, widget.id),
      body: Body(id: widget.id),
    );
  }
}

class Body extends StatefulWidget {
  String id ="id";
  Body({super.key, required this.id});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final customerApiProvider = CustomerApiProvider();
  @override
  initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade300,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: _buildSearch(context),
              ),
            ),
            //Banner
            Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 190,
                      // ignore: missing_required_param
                      child: StreamBuilder(
                        stream: customerApiProvider.banner.snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.hasData){
                            return CarouselSlider(
                              items: snapshot.data!.docs.map((DocumentSnapshot document) {
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                          image: NetworkImage(document['image']),
                                          fit: BoxFit.cover)),
                                );
                              }).toList(),
                              options: CarouselOptions(
                                height: 180.0,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                                viewportFraction: 0.8,
                              ),
                            );
                          }
                          else if(snapshot.hasError){}
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                )
            ),
            //Danh muc
            Container(
              height: 250,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 15,
                    offset: Offset(0, 6),
                  ),
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute (
                              builder: (BuildContext context) => ProductListWidget('Điện thoại','Điện Thoại', widget.id),
                            ));
                          },
                          child: const Image(
                            width: 70,
                            height: 70,
                            image: AssetImage("assets/images/phone (2).png"),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: const Text('Điện thoại',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),)
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute (
                              builder: (BuildContext context) =>  ProductListWidget('Máy tính bảng','Máy Tính Bảng',widget.id),
                            ));
                          },
                          child:  const Image(
                            width: 70,
                            height: 70,
                            image: AssetImage("assets/images/tablet.png"),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: const Text('Máy tính bảng',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),)
                        )
                      ],
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute (
                              builder: (BuildContext context) =>  ProductListWidget('Laptop', 'Laptop',widget.id),
                            ));
                          },
                          child:  const Image(
                            width: 70,
                            height: 70,
                            image: AssetImage("assets/images/laptop.png"),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: const Text('Laptop',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),)
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute (
                              builder: (BuildContext context) =>  ProductListWidget('Đồng hồ thông minh','Đồng Hồ Thông Minh',widget.id),
                            ));
                          },
                          child:  const Image(
                            width: 70,
                            height: 70,
                            image: AssetImage("assets/images/smartwatch.png"),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: const Text('Đồng hồ thông minh',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),)
                        )
                      ],
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute (
                              builder: (BuildContext context) =>  ProductListWidget('PC-Lắp ráp', 'Máy Tính Bàn và Phụ Kiện',widget.id),
                            ));
                          },
                          child:  const Image(
                            width: 70,
                            height: 70,
                            image: AssetImage("assets/images/PC.png"),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: const Text('PC - Lắp ráp',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),)
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute (
                              builder: (BuildContext context) =>  ProductListWidget('Tai nghe','Tai nghe',widget.id),
                            ));
                          },
                          child:  const Image(
                            width: 70,
                            height: 70,
                            image: AssetImage("assets/images/headphone.png"),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: const Text('Tai nghe',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),)
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //Flash Sale
            StreamBuilder(
                stream: customerApiProvider.product.where("active", isEqualTo: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasData){
                    List<ProductModel> list = snapshot.data!.docs.isNotEmpty
                        ? snapshot.data!.docs.map((e) => ProductModel.toMap(e)).toList(): [];
                    List<ProductModel> list_sale = [];
                    for(int i=0; i<list.length;i++){
                      if(list[i].discountPercentage >= 15){
                        list_sale.add(list[i]);
                      }
                    }
                    return FlashSale(list_sale);
                  }
                  else if(snapshot.hasError) {
                    print('Lỗi: ${snapshot.error}');
                    return Container();
                  }
                  return const Center(child: CircularProgressIndicator());
                }
            ),
            //Sản phẩm nổi bật
            StreamBuilder(
                stream: customerApiProvider.product
                    .where('collection', isEqualTo: 'Sản phẩm nổi bật')
                    .where("active", isEqualTo: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasData){
                      List<ProductModel> list = snapshot.data!.docs.isNotEmpty
                          ? snapshot.data!.docs.map((e) => ProductModel.toMap(e)).toList()
                          : [];
                      return ProductLoadMore(list,'Sản Phẩm Nổi Bật');
                    }
                    else if(snapshot.hasError) {
                      print('Lỗi: ${snapshot.error}');
                      return Container();
                    }
                    return const Center(child: CircularProgressIndicator());
                }
            ),
          ]
      ),
    );
  }
}

TextField _buildSearch(BuildContext context) {
  const border =  OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
      width: 1,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(15.0),
    ),
  );

  const sizeIcon = BoxConstraints(
    minWidth: 40,
    minHeight: 40,
  );

  return TextField(
    readOnly: true,
    onTap: (){
      Navigator.of(context).push(MaterialPageRoute (
        builder: (BuildContext context) => SearchScreen(),
      ));
    },
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(4),
      focusedBorder: border,
      enabledBorder: border,
      isDense: true,
      hintText: "Tìm kiếm",
      hintStyle: TextStyle(
        fontSize: 18,
        color: Colors.grey,
      ),
      prefixIcon: Icon(
        Icons.search,
        color: Colors.white,
      ),
      prefixIconConstraints: BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      ),
      suffixIcon: Icon(
        Icons.search,
      ),
      suffixIconConstraints: sizeIcon,
      filled: true,
      fillColor: Colors.white,
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