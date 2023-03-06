import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/components/appbar.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/view/card/widgets/product_load_more.dart';
import 'package:store_app/view/order/product_cart_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var customerApiProvider = CustomerApiProvider();
  User? user = FirebaseAuth.instance.currentUser;
  var txtSearch = TextEditingController();
  String search ="";
  List<String> list = [];
  bool complete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade300,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: mFontSize,
            ),
            onPressed: () => Navigator.of(context).pop()),
        title: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: txtSearch,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(4),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                          isDense: true,
                          hintText: "Tìm kiếm",
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 10,
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          suffixIcon:  Icon(
                            Icons.search,
                          ),
                          suffixIconConstraints: BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        /*onChanged: (value){
                          setState(() {
                            search = txtSearch.text;
                            list.add(value);
                          });
                        },*/
                        onTap: (){
                          setState(() {
                            complete = false;
                          });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            search = txtSearch.text;
                            complete = true;
                          });
                          var searchHistory = customerApiProvider.customer.doc(customerApiProvider.user!.uid)
                              .collection("search history");
                          searchHistory.where("value", isEqualTo: search).get().then((value) {
                            print(value.docs.length);
                            if(value.docs.isEmpty) {
                              searchHistory.add({
                                "value": search
                              });
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Stack(
                      children: <Widget>[
                        IconButton(
                          iconSize: 28,
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            if(prefs.getString('ID') == ''|| prefs.getString('ID') == null){
                              ListAppBar().Dialog(context);
                            }
                            else{
                              Navigator.of(context).pushReplacement(MaterialPageRoute (
                                  builder: (BuildContext context) => ProductScreen(prefs.getString('ID')!)));
                            }
                          },
                          icon: const Icon(MdiIcons.cartOutline,),
                          color: Colors.white,
                        ),
                        StreamBuilder(
                          stream: customerApiProvider.cart.doc(user!.uid).collection('products').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if(snapshot.hasData){
                              return snapshot.data!.docs.isEmpty
                                  ? const SizedBox()
                                  : Positioned(
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 22,
                                    minHeight: 22,
                                  ),
                                  child: Text(
                                    '${snapshot.data!.docs.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            else if(snapshot.hasError){
                              return Text(snapshot.error.toString());
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: complete == false?
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Container(
                //color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: const Text(
                  "Lịch sử tìm kiếm",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: mFontTitle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              StreamBuilder(
                  stream: customerApiProvider.customer.doc(customerApiProvider.user!.uid).collection("search history").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasData){
                      return buildList(snapshot.data!.docs);
                    }
                    else if(snapshot.hasError) {
                      print('Lỗi: ${snapshot.error}');
                      return Container();
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
              )
            ],
          ),
        ):
        FutureBuilder(
            future: customerApiProvider.search(search),
            builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
              if(snapshot.hasData){
                List<ProductModel> list = snapshot.data!.isEmpty
                    ? []: snapshot.data!;
                if(snapshot.data!.isEmpty){
                  return Container(
                    //color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Text(
                      "Chúng tôi không tìm thấy sản phẩm $search nào",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: mFontTitle,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return ProductLoadMore(list,"Từ khóa: $search");
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
  buildList(List list){
    return GridView.builder(
      padding: const EdgeInsets.all(3),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2.8,
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (BuildContext context, int index) {
        return buildItem(list[index]);
      },
    );
      /*ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index){
          return buildItem(list[index]);
        }
    );*/
  }

  buildItem(DocumentSnapshot document){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey)
      ),
      child: TextButton(
        onPressed: (){
          setState(() {
            search = document["value"];
            txtSearch.text = document["value"];
            complete = true;
          });
        },
        child: Text(document["value"]),
      ),
    );
  }
}