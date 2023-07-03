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
  List users = [];
  List<ProductModel> products = [];
  List<Set<dynamic>> list_value = [];
  List<Set<dynamic>> list_rate = [];
  List<Set<dynamic>> list_product_recommend = [];
  List<ProductModel> _productViewModel = [];

  getListReview() async {
    List<Set<dynamic>> listvalue = [];
    await customerApiProvider.customer.get().then((value) async {
      for(var user in value.docs.toList()) {
        await customerApiProvider.customer.doc(user.id).collection("review").where(
            "rate", isGreaterThan: 0).get().then((value2) {
          if(value2.docs.isNotEmpty) {
            for(var doc in value2.docs) {
              listvalue.add({user.id, doc.data()["productId"], doc.data()["rate"]});
            }
          }
        });
      }
    });
    setState(() {
      list_value = listvalue;
    });
  }

  getListProduct() async {
    await customerApiProvider.product.get().then((value) {
      for(var product in value.docs.toList()) {
        products.add(ProductModel.fromMap(product));
      }
    });
    diffirenceProduct();
  }

  diffirenceProduct(){
    List<List<Set<dynamic>>> list = [];
    for(int i = 0; i < products.length; i++){
      List<Set<dynamic>> list_user_use_product_1 = [];
      for(var matrix in list_value){
        if(matrix.toList()[1] == products[i].id){
          list_user_use_product_1.add({matrix.toList()[0], matrix.toList()[2]});
        }
      }
      list.add(list_user_use_product_1);
    }
    for(int i = 0; i < list.length; i++){
      for(int j = i +1; j < list.length; j++){
        getRate(list[i], list[j], i , j);
      }
    }
  }

  getListRecommend() async {
    List<Set<dynamic>> list_product_reviewed = [];
    List<String> list_product_not_review = [];
    await customerApiProvider.customer.doc(customerApiProvider.user!.uid).collection("review").where(
        "rate", isGreaterThan: 0).get().then((value) {
      if(value.docs.isNotEmpty) {
        for(var doc in value.docs) {
          list_product_reviewed.add({doc.data()["productId"], doc.data()["rate"]});
        }
      }
    });

    for(var product in products){
      if(!list_product_reviewed.contains(product.id)){
        list_product_not_review.add(product.id);
      }
    }

    for(var not_review in list_product_not_review){
      double final_rate = 0;
      double total_temp = 0;
      for(var reviewed in list_product_reviewed){
        for(var rate in list_rate){
          if(rate.toList()[0] == not_review && rate.toList()[1] == reviewed.toList()[0]){
            final_rate = final_rate + ((reviewed.toList()[1] as double) + (rate.toList()[2] as double)) * int.parse(rate.toList()[3]);
            total_temp = total_temp + int.parse(rate.toList()[3]);
          }
        }
      }
      if(total_temp == 0){
        //list_product_recommend.add({not_review, 0});
      }else {
        list_product_recommend.add({not_review, final_rate/total_temp});
      }
    }
    for (int i = 0; i < list_product_recommend.length - 1; i++)
    {
      //j sẽ được duyệt từ vị trí của phân tử chưa sắp xếp tới cuối mảng
      for (int j = i + 1; j < list_product_recommend.length; j++)
      {
        //Nếu phần tử đang kiểm tra(a[i]) bé hơn phần tử khi ta duyệt mảng để kiểm tra(a[j])
        if(list_product_recommend[i].toList()[1] < list_product_recommend[j].toList()[1])
        {
          //Ta đảo vị trí của 2 phần tử
          Set<dynamic> temp = list_product_recommend[i];
          list_product_recommend[i] = list_product_recommend[j];
          list_product_recommend[j] = temp;
        }
      }
    }
  }

  getRate(List<Set<dynamic>> list_a, List<Set<dynamic>> list_b, int i, int j){
    int temp = 0;double rate = 0;
    for(int i = 0; i < list_a.length; i++){
      for(int j = 0; j < list_b.length; j++){
        if(list_b[j].toList()[0] == list_a[i].toList()[0]){
          temp = temp + 1;
          rate = rate + (list_a[i].toList()[1] as double) - (list_b[j].toList()[1] as double);
        }
      }
    }
    if(temp == 0) {
      list_rate.add({products[i].id, products[j].id, rate, temp.toString()});
    } else {
      list_rate.add({products[i].id, products[j].id, rate/temp, temp.toString()});
    }
  }

  user() async {

    await getListReview();
    await getListProduct();
    await getListRecommend();

    for(var i =0; i < list_product_recommend.length; i++) {
      print(list_product_recommend[i]);
      for(var product in products){
        if(product.id == list_product_recommend[i].toList()[0]){
          _productViewModel.add(product);
        }
      }
    }
    setState(() {
      _productViewModel = _productViewModel;
    });
  }

  @override
  initState() {
    super.initState();
    user();
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
                height: 190,
                //color: Colors.blueAccent,
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
                                  fit: BoxFit.fill
                                )),
                          );
                        }).toList(),
                        options: CarouselOptions(
                            enlargeCenterPage: true,
                            autoPlay: true,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                            viewportFraction: 0.91,
                            enlargeFactor : 0.2
                        ),
                      );
                    }
                    else if(snapshot.hasError){}
                    return const Center(child: CircularProgressIndicator());
                  },
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
                    blurRadius: 5,
                    spreadRadius: 1,
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
                          child: Image.network(
                            'https://img.freepik.com/premium-vector/black-smartphone-isolated_175654-441.jpg?size=626&ext=jpg&ga=GA1.2.201965199.1683464414&semt=sph',
                            width: 70,
                            height: 70,
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
                          child: Image.network(
                            'https://img.freepik.com/free-psd/laptop-mock-up-design_1307-41.jpg?size=626&ext=jpg&ga=GA1.1.201965199.1683464414&semt=sph',
                            width: 70,
                            height: 70,
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
                          child: Image.network(
                            'https://img.freepik.com/premium-photo/black-modern-smart-watch-mockup-with-strap-white-background-3d-rendering_476612-18548.jpg?size=626&ext=jpg&ga=GA1.2.201965199.1683464414&semt=ais',
                            width: 70,
                            height: 70,
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
                          child: Image.network(
                            'https://img.freepik.com/premium-vector/modern-computer_108855-821.jpg?size=626&ext=jpg&ga=GA1.2.201965199.1683464414&semt=sph',
                            width: 70,
                            height: 70,
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
                          child: Image.network(
                            'https://img.freepik.com/premium-photo/black-gaming-headphone-isolated-white-background-generative-ai_834602-212.jpg?size=626&ext=jpg&ga=GA1.2.201965199.1683464414&semt=sph',
                            width: 70,
                            height: 70,
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
            ProductLoadMore(_productViewModel,'Gợi ý hôm nay')
            /*FutureBuilder(
                future: user(),
                builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
                  if(snapshot.hasData){
                    return ProductLoadMore(snapshot.data!,'Gợi ý hôm nay');
                  }
                  else if(snapshot.hasError) {
                    print('Lỗi: ${snapshot.error}');
                    return Container();
                  }
                  return const Center(child: CircularProgressIndicator());
                }
            ),*/
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
    decoration: const InputDecoration(
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