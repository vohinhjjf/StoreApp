import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/constant.dart';
import 'package:video_player/video_player.dart';

import '../../../models/review_model.dart';

class ListReviewed extends StatefulWidget {

  const ListReviewed({super.key});

  @override
  _ListReviewedState createState() => _ListReviewedState();
}

class _ListReviewedState extends State<ListReviewed> {
  final customerApiProvider = CustomerApiProvider();
  List<ReviewModel> list = [];
  List<String> list_image = [];
  List<VideoPlayerController> list_video = [];
  bool loading = false;
  bool loading_image = false;

  @override
  void initState() {
    super.initState();
    selectData();
  }
  
  Future<void> selectData() async {
    await customerApiProvider.getListReviewed().then((value) =>
      list = value
    );
    setState(() {
      loading = true;
    });
    for(var review in list){
      for(var url in review.reviewImage){
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
      loading_image = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading? buildList():
    const Center(child: CircularProgressIndicator());
  }

  Widget buildList() {
    return ListView(
        padding: const EdgeInsets.only(top: 10),
        children: list.map((ReviewModel reviewModel) {
          return  buildData(reviewModel);
        }).toList()
    );
  }

  Widget buildData(ReviewModel reviewModel) {
    return FutureBuilder(
        future: customerApiProvider.product.doc(reviewModel.productId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> docSnapshot){
          if (docSnapshot.hasData) {
            if (docSnapshot.data!.exists) {
              Map<String, dynamic> data = docSnapshot.data!.data()!;
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    shadowColor: Colors.grey,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade400, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    //margin: EdgeInsets.fromLTRB(5, space_height, 5, 0),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () async {

                      },
                      child: Container(
                        width: 300,
                        //height: 185,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Column(
                          crossAxisAlignment : CrossAxisAlignment.start,
                          children: [
                            Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Image.network(
                                      data["image"],
                                      height: 65,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          data["name"],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                          const TextStyle(fontSize: mFontListTile, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 5,),
                                        const Text("Phân loại: ",
                                            style: TextStyle(color: Colors.grey, fontSize: mFontListTile)),
                                      ],
                                    ),
                                  ),
                                ]
                            ),
                            const SizedBox(height: 5,),
                            const Divider(height: 5,color: Colors.grey,),
                            const SizedBox(height: 5,),
                            RatingBar.builder(
                              initialRating: reviewModel.rate,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 28,
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
                              reviewModel.time,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              reviewModel.detailedReview,
                              //maxLines: 1,
                              style:
                              const TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            //;const SizedBox(height: 5,),
                            loading_image? GridView(
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
                                    return Image.network(
                                      data,
                                      cacheHeight: 200,
                                      cacheWidth: 200,
                                    );
                                  }).toList(),
                                  ...list_video.map((data) {
                                    return SizedBox(
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
                            ):
                            const Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      ),
                    ),
                  )
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