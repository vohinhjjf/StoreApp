import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:store_app/components/appbar.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/utils/format.dart';
import 'package:video_player/video_player.dart';

import '../../Firebase/firebase_realtime_data_service.dart';

class ProductDetailScreen extends StatefulWidget {
  String id ="id";
  Function() onPressed;
  final ProductModel product;
  ProductDetailScreen(this.product, this.onPressed,{required this.id});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final customerApiProvider = CustomerApiProvider();
  User? user = FirebaseAuth.instance.currentUser;
  late Timer _timer;
  List<String> list_image = [];
  List<VideoPlayerController> list_video = [];
  bool loading = false;
  bool like = false;
  double rate = 0;

  @override
  void initState() {
    super.initState();
    selectData();
  }



  Future<void> selectData() async {
    List list = [];
    await customerApiProvider.product.doc(widget.product.id)
        .collection('review').get().then((value) => {
        list = value.docs,
      }
    );
    for(var review in list){
      rate = (rate + review['rate'])/list.length;
      for(var url in review['reviewImage']){
        await validateImage(url).then((value) async {
          if(value){
            list_image.add(url);
          }else{
            await _playVideo(url);
          }
        });
      }
    }
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: ListAppBar().AppBarProduct(context, "Thông tin sản phẩm", widget.id, widget.onPressed),
      body: SingleChildScrollView(
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.only(
              //     topRight: Radius.circular(56),
              //     topLeft: Radius.circular(56)),
            ),
            width: size.width,
            //height: 30,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.product.image,
                    //height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(widget.product.name,
                      style: const TextStyle(
                          fontSize: mFontTitle,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPrice(),
                      StreamBuilder(
                          stream: customerApiProvider.checkFavorite(widget.product.id).asStream(),
                          builder: (context, AsyncSnapshot<bool> snapshot){
                            if(snapshot.hasData){
                              return IconButton(
                                iconSize: 28,
                                onPressed: () {
                                  setState(() {
                                    if(snapshot.data!){
                                      customerApiProvider.unfavoriteProduct(
                                          widget.product.id);
                                    }
                                    else {
                                      customerApiProvider.favoriteProduct(
                                          widget.product.id);
                                    }
                                  });
                                },
                                icon: snapshot.data!
                                    ?const Icon(MdiIcons.heart,)
                                    :const Icon(MdiIcons.heartOutline,),
                                color: Colors.red,
                              );
                            } else if(snapshot.hasError){
                              return Container();
                            }
                            return const CircularProgressIndicator();
                          }
                      )
                    ],
                  ),
                  if (widget.product.discountPercentage != 0) Row(
                    children: [
                      Text(
                        '${Format().currency(widget.product.price, decimal: false).replaceAll(RegExp(r','), '.')}đ',
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Text(
                        "${widget.product.discountPercentage}%",
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: mDividerColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text(
                          "Chi tiết sản phẩm",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: mFontTitle,
                            color: Colors.black),
                      ),
                      trailing: Container(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Kho, gửi từ", style: TextStyle(fontSize: 16)),
                            Icon(Icons.arrow_forward_ios, size: 18,),
                          ],
                        ),
                      ),
                      onTap: (){
                        showBottomSheet(context);
                      }
                  ),
                  const Divider(
                    color: mDividerColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Mô tả sản phẩm",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: mFontTitle,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.product.details,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: mFontListTile,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: mDividerColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  StreamBuilder(
                      stream: customerApiProvider.product.doc(widget.product.id)
                          .collection('review').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> docSnapshot){
                        if (docSnapshot.hasData) {
                          if (docSnapshot.data!.docs.isEmpty) {
                            return Column(
                              children: [
                                ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Đánh Giá Sản Phẩm",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: mFontTitle,
                                              color: Colors.black),
                                        ),
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              initialRating: 0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 20,
                                              itemPadding: const EdgeInsets.symmetric(vertical: 5),
                                              itemBuilder: (context, _) => const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              glow: true,
                                              onRatingUpdate: (rating) {},
                                            ),
                                            const Text(
                                              "0/5",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: mFontListTile,
                                                  color: Colors.red),
                                            ),
                                            Text(
                                              "(0 đánh giá)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: mFontListTile,
                                                  color: Colors.grey.shade400),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container()
                              ],
                            );
                          }
                          return Column(
                            children: [
                              ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Đánh Giá Sản Phẩm",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: mFontTitle,
                                            color: Colors.black),
                                      ),
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            initialRating: rate,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 20,
                                            itemPadding: const EdgeInsets.symmetric(vertical: 5),
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            glow: true,
                                            onRatingUpdate: (rating) {},
                                          ),
                                          Text(
                                            "$rate/5",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: mFontListTile,
                                                color: Colors.red),
                                          ),
                                          Text(
                                            "(${docSnapshot.data!.docs.length} đánh giá)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: mFontListTile,
                                                color: Colors.grey.shade400),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("Xem tất cả",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.redAccent
                                            )
                                        ),
                                        Icon(Icons.arrow_forward_ios, size: 18,color: Colors.redAccent),
                                      ],
                                    ),
                                  ),
                                  onTap: (){

                                  }
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              buildList(docSnapshot.data!.docs)
                            ],
                          );
                        }
                        else if (docSnapshot.hasError) {
                          print("Error 2");
                          return Text(docSnapshot.error.toString());
                        }
                        return const Center(child: CircularProgressIndicator());
                      }
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                ],
              ),
            )
        ),
      ),
      bottomSheet: Row(
        children: [
          Flexible(
              flex: 1,
              child: InkWell(
                onTap: () {
                  customerApiProvider.addToCart(widget.product).then((value) {
                    setState(() {
                      Dialog(context);
                    });
                  });
                },
                child: Container(
                  height: 56,
                  color: Colors.red[400],
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            MdiIcons.cartOutline,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Thêm vào giỏ hàng',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: mFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }

  Widget buildList(List<QueryDocumentSnapshot> list){
    return ListView(
      //padding: const EdgeInsets.only(top: 10),
        shrinkWrap: true,
        primary: false,
        children: list.map((DocumentSnapshot documentSnapshot) {
          return  buildData(documentSnapshot);
        }).toList()
    );
  }

  Widget buildData(DocumentSnapshot document) {
    return StreamBuilder(
        stream: customerApiProvider.customer.doc(document['userId']).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> docSnapshot){
          if (docSnapshot.hasData) {
            if (docSnapshot.data!.data()!.isNotEmpty) {
              Map<String, dynamic> data = docSnapshot.data!.data()!;
              return Card(
                shadowColor: Colors.grey,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                //margin: EdgeInsets.fromLTRB(5, space_height, 5, 0),
                child: InkWell(
                  onTap: () async {

                  },
                  child: Container(
                    //width: 300,
                    //height: 185,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  data["image"],
                                ),
                                radius: 45,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 10,
                            child: Column(
                              crossAxisAlignment : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data["name"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                  const TextStyle(fontSize: mFontListTile, fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(height: 5,),
                                RatingBar.builder(
                                  initialRating: document["rate"],
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemPadding: const EdgeInsets.symmetric(vertical: 5),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  glow: true,
                                  onRatingUpdate: (rating) {},
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  document['time'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                  const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  document['detailedReview'],
                                  //maxLines: 1,
                                  style:
                                  const TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                const SizedBox(height: 5,),
                                loading
                                    ?GridView(
                                  padding: const EdgeInsets.all(10.0),
                                  shrinkWrap: true,
                                  primary: false,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 15,
                                  ),
                                  children: [
                                    ...list_image.map((data) {
                                      //validateImage(data).then((value) => print("Type: $value}"));
                                      return Image.network(
                                        data,
                                        cacheHeight: 200,
                                        cacheWidth: 200,
                                      );
                                    }).toList(),
                                    ...list_video.map((data) {
                                      //validateImage(data).then((value) => print("Type: $value}"));
                                      return Container(
                                        height: 200,
                                        width: 200,
                                        child: AspectRatio(
                                          aspectRatio: data.value
                                              .aspectRatio,
                                          child: Stack(
                                            alignment: Alignment
                                                .bottomCenter,
                                            children: <Widget>[
                                              VideoPlayer(data),
                                              _ControlsOverlay(
                                                  data),
                                              VideoProgressIndicator(
                                                  data,
                                                  allowScrubbing: true),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ]
                                )
                                    :const Center(child: CircularProgressIndicator()),
                              ],
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              );
            }
            return Container();
          }
          else if (docSnapshot.hasError) {
            print("Error 2");
            return Text(docSnapshot.error.toString());
          }
          return const Center(child: CircularProgressIndicator());
        }
    );
  }

  Future<bool> validateImage(String imageUrl) async {
    http.Response res;
    try {
      res = await http.get(Uri.parse(imageUrl));
    } catch (e) {
      return false;
    }

    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    return checkIfImage(data['content-type']);
  }

  bool checkIfImage(String param) {
    if (param == 'image/jpeg' || param == 'image/png' || param == 'image/gif') {
      return true;
    }
    return false;
  }

  Future<void> _playVideo(dynamic data) async {
    VideoPlayerController controller = VideoPlayerController.network(data);
    await controller.initialize();
    await controller.setLooping(true);
    await controller.pause();

    setState(() {
      list_video.add(controller);
    });
  }

  showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white,
        elevation: 2,
        builder: (BuildContext context) {
          return Container(
            height: 320,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200, width: 2),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
            child: Column(
              children: <Widget>[
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                      'Chi tiết sản phẩm',
                    style: TextStyle(
                      fontSize: mFontTitle,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ListTile(
                    //contentPadding: const EdgeInsets.all(5),
                    leading: const Text('Kho',
                        style: TextStyle(
                            fontSize: mFontSize,
                            fontWeight: FontWeight.bold
                        )),
                    title: const Text('10',
                        style: TextStyle(
                            fontSize: mFontListTile,
                            //fontWeight: FontWeight.bold
                        )),
                    onTap: (){},
                ),
                Container(
                  color: Colors.grey.shade50,
                  height: 1,
                  width: double.infinity,
                ),
                ListTile(
                    //contentPadding: const EdgeInsets.all(0),
                    leading: const Text('Độ tuổi phù hợp',
                        style: TextStyle(
                            fontSize: mFontSize,
                            fontWeight: FontWeight.bold
                        )),
                    title: const Text('16+',
                        style: TextStyle(
                            fontSize: mFontListTile,
                            //fontWeight: FontWeight.bold
                        )),
                    onTap: (){}
                ),
                Container(
                  color: Colors.grey.shade50,
                  height: 1,
                  width: double.infinity,
                ),
                ListTile(
                    //contentPadding: const EdgeInsets.all(0),
                    leading: const Text('Xuất xứ',
                        style: TextStyle(
                            fontSize: mFontSize,
                            fontWeight: FontWeight.bold
                        )),
                    title: const Text('Việt Nam',
                        style: TextStyle(
                            fontSize: mFontListTile,
                            //fontWeight: FontWeight.bold
                        )),
                    onTap: (){}
                ),
                Container(
                  color: Colors.grey.shade50,
                  height: 1,
                  width: double.infinity,
                ),
                ListTile(
                    //contentPadding: const EdgeInsets.all(0),
                    leading: const Text('Dòng sản phẩm',
                        style: TextStyle(
                            fontSize: mFontSize,
                            fontWeight: FontWeight.bold
                        )),
                    title: Text('${widget.product.category}',
                        style: const TextStyle(
                            fontSize: mFontListTile,
                            //fontWeight: FontWeight.bold
                        )),
                    onTap: (){}
                ),
              ],
            ),
          );
        },
        context: (context)
    );
  }

  RichText _buildPrice() => RichText(
    text: TextSpan(
      text: '${Format().currency(widget.product.price*(100-widget.product.discountPercentage)/100, decimal: false).replaceAll(RegExp(r','), '.')}đ',
      style: const TextStyle(
          fontSize: 20,
          color: Colors.red,
        fontWeight: FontWeight.bold
      ),
    ),
  );

  Dialog(BuildContext context) {
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

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay(this.controller, {super.key});

  final VideoPlayerController? controller;

  @override
  ControlsOverlayState createState() => ControlsOverlayState();
}

class ControlsOverlayState extends State<_ControlsOverlay> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller!.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                Icons.play_circle,
                color: Colors.grey,
                size: 30.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              print("1");
              widget.controller!.value.isPlaying ? widget.controller!.pause() : widget.controller!.play();
            });
          },
        ),
      ],
    );
  }
}
