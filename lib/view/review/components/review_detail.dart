import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/models/review_model.dart';
import 'package:video_player/video_player.dart';

import '../review_screen.dart';

class ReviewDetail extends StatefulWidget{
  final CartModel cartModel;
  const ReviewDetail({super.key, required this.cartModel});

  @override
  _ReviewDetailState createState() => _ReviewDetailState();
}

class _ReviewDetailState extends State<ReviewDetail> {
  final customerApiProvider = CustomerApiProvider();
  TextEditingController descriptionController = TextEditingController();
  List<XFile> list_file = [];
  List<XFile> list_imageFile = [];
  List<VideoPlayerController> list_videoFile = [];
  final ImagePicker picker = ImagePicker();
  double rate = 5;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: mPrimaryColor,
                size: mFontListTile,
              ),
              onPressed: () => Navigator.of(context).pop()),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Đánh giá sản phẩm',
            style: TextStyle(
              fontSize: mFontTitle,
              color: mPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
          color: Colors.grey.shade300,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 9,
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Image.network(
                              widget.cartModel.productImage,
                              width: 65,
                              height: 65,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width-110,
                                child: Text(
                                  widget.cartModel.productName,
                                  style: const TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'Số lượng: ${widget.cartModel.amount}',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 0),
                            child: const Text('Chất lượng sản phẩm',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                                ),
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: rate,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 28,
                            itemPadding: const EdgeInsets.only(top: 10, left: 0, bottom: 10, right: 10),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                rate = rating;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, left: 10, bottom: 0, right: 10),
                      color: Colors.white,
                      child: const Text('Nhập 50 kí tự',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: TextFormField(
                        minLines: 5,
                        maxLines: 10,
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText: 'Hãy chia sẽ nhận xét cho sản phẩm này bạn nhé!',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: mFontListTile),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      color: Colors.white,
                      child: const Text('Tải lên hình ảnh',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey
                        ),
                      ),
                    ),
                    Container(
                      //height: 200,
                      color: Colors.white,
                      child: imageData(),
                    ),
                    Container(
                      //height: 200,
                      color: Colors.white,
                      child: videoData(),
                    ),

                    Container(
                      height: 25,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade400))
                  ),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: OutlinedButton(
                      onPressed: () async {
                        showLoaderDialog(context);
                        String time = DateTime.now().toString();
                        List<String> list_url = [];
                        for(int i = 0; i< list_file.length ; i++) {
                          print(list_file[i]);
                          await customerApiProvider.uploadImageVideo(list_file[i], i, time).then((value) {
                            list_url.add(value);
                          });
                        }
                        ReviewModel reviewModel = ReviewModel(
                            productId: widget.cartModel.productId,
                            detailedReview: descriptionController.text,
                            reviewImage: list_url,
                            rate: rate,
                            time: DateTime.now().toString()
                        );
                        Timer(const Duration(seconds: 2), () {
                          customerApiProvider.addReview(reviewModel, widget.cartModel.purchaseId);
                          Navigator.pop(context);
                          _showMaterialDialog();
                        });
                      },
                      autofocus: true,
                      style: OutlinedButton.styleFrom(
                        //minimumSize: MediaQuery.of(context).size,
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: mError, width: 1),
                          shape: const RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(5))
                          )
                      ),
                      child:  const Text(
                        "Gửi",
                        style: TextStyle(color: mError, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      try {
        VideoPlayerController controller = VideoPlayerController.file(
            File(file.path));
        await controller.initialize();
        await controller.setLooping(true);
        await controller.pause();
        print("Giây: ${controller.value.duration.inSeconds}");
        if(controller.value.duration.inSeconds < 3
            || controller.value.duration.inSeconds > 30){
          Dialog(context);
        } else {
          Navigator.of(context).pop();
          setState(() {
            list_videoFile.add(controller);
            list_file.add(file);
          });
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  void _openGallary(ImageSource source) async {
    final media = await picker.pickImage(source: source);
    print("Image: "+media!.path.toString());
    setState(() {
      list_imageFile.add(media);
      list_file.add(media);
    });

    Navigator.of(context).pop();
  }

  void _openVideo(ImageSource source) async {
    final media = await picker.pickVideo(source: source);
    await _playVideo(media);
  }

  Widget imageData() {
    return GridView(
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: true,
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 15,
        ),
        children:[
          ...list_imageFile.map((data) {
            return Stack(
              children: [
                Image.file(
                  File(data.path),
                  cacheHeight: 200,
                  cacheWidth: 200,
                ),
                GestureDetector(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                          'assets/icons/cancel.png',
                          height: 25
                      ),
                    ),
                    onTap:(){
                      setState(() {
                        list_imageFile.remove(data);
                      });
                    }
                )
              ],
            );
          }).toList(),
          list_imageFile.length < 5
              ?Container(
              decoration: ShapeDecoration(
                color: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  //side: const BorderSide(color: mPrimaryColor, width: 2),
                    borderRadius: BorderRadius.circular(5)
                ),
              ),
              height: 200,
              width: 200,
              child: MaterialButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheetImage()),
                  );
                },
                height: 200,
                minWidth: 200,
                //padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                          'assets/icons/photo-camera.png',
                          //color: darkGrey,
                          height: 35
                      ),
                    ),
                    const Text(
                      'Tải lên hình ảnh',
                      style: TextStyle(
                        fontSize: 15,
                        color: darkGrey,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              )
          )
              : Container()
        ]
    );
  }

  Widget videoData() {
    return GridView(
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: true,
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 15,
        ),
        children:[
          ...list_videoFile.map((data) {
            return Stack(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  child: AspectRatio(
                    aspectRatio: data.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        VideoPlayer(data),
                        _ControlsOverlay(data),
                        VideoProgressIndicator(data, allowScrubbing: true),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                          'assets/icons/cancel.png',
                          height: 25
                      ),
                    ),
                    onTap:(){
                      setState(() {
                        list_videoFile.remove(data);
                      });
                    }
                )
              ],
            );
          }).toList(),
          list_videoFile.length < 2
              ?Container(
              decoration: ShapeDecoration(
                color: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  //side: const BorderSide(color: mPrimaryColor, width: 2),
                    borderRadius: BorderRadius.circular(5)
                ),
              ),
              height: 200,
              width: 200,
              child: MaterialButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheetVideo()),
                  );
                },
                height: 200,
                minWidth: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                          'assets/icons/play.png',
                          //color: darkGrey,
                          height: 35
                      ),
                    ),
                    const Text(
                      'Tải lên video',
                      style: TextStyle(
                        fontSize: 15,
                        color: darkGrey,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              )
          )
              : Container()
        ]

    );
  }

  Widget bottomSheetImage() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text("Chọn ảnh", style: TextStyle(fontSize: mFontSize)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                  onPressed: () => _openGallary(ImageSource.camera),
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera", style: TextStyle(fontSize: mFontSize))),
              TextButton.icon(
                  onPressed: () => _openGallary(ImageSource.gallery),
                  icon: const Icon(Icons.collections),
                  label: const Text("Thư viện", style: TextStyle(fontSize: mFontSize))),
            ],
          )
        ],
      ),
    );
  }

  Widget bottomSheetVideo() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text("Chọn video", style: TextStyle(fontSize: mFontSize)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                  onPressed: () => _openVideo(ImageSource.camera),
                  icon: const Icon(Icons.camera),
                  label: const Text("Video", style: TextStyle(fontSize: mFontSize))),
              TextButton.icon(
                  onPressed: () => _openVideo(ImageSource.gallery),
                  icon: const Icon(Icons.collections),
                  label: const Text("Thư viện", style: TextStyle(fontSize: mFontSize))),
            ],
          )
        ],
      ),
    );
  }

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
                Text(
                  'Độ dài video phải dài hơn 3 giây\nvà ngắn hơn 30 giây',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: const Image(
            width: 130,
            height: 130,
            image: AssetImage("assets/images/success.gif"),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: const Text(
                  "Đánh giá thành công. Hãy quay lại trang chủ!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                        child: const Text('Quay lại',
                            style: TextStyle(
                                color: mPrimaryColor, fontSize: 15)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ReviewScreen();
                              },
                            ),
                          );
                        }),
                  ])
            ],
          ),
        ));
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
