import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/request_support_model.dart';


class SupportRequestScreen extends StatefulWidget {
  @override
  _SupportRequestScreenState createState() => _SupportRequestScreenState();
}

class _SupportRequestScreenState extends State<SupportRequestScreen> {
  List<String> problems = [
    "Tài khoản",
    "Sản phẩm",
    "Ưu đãi",
    "Thanh toán",
    "Lỗi ứng dụng"
  ];
  String problem = "";
  RequestSupportModel requestModel = RequestSupportModel();
  TextEditingController descriptionController = TextEditingController();

  PickedFile? imageFile ;
  final ImagePicker picker = ImagePicker();
  final customerApiProvider = CustomerApiProvider();


  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: mPrimaryColor,
              size: mFontSize,
            ),
            onPressed: () => Navigator.pop(context),),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Trung tâm hỗ trợ',
          style: TextStyle(
            fontSize: mFontSize,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                margin: const EdgeInsets.only(top: space_height),
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: problem.isEmpty
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Chọn vấn đề hỗ trợ",
                            style: TextStyle(
                                fontSize: mFontSize,
                                color: mPrimaryColor,
                                fontWeight: FontWeight.w600)),
                        IconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: mPrimaryColor,
                            ),
                            onPressed: () {
                              showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                        height: 300,
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: const [
                                                Center(
                                                    child: Text(
                                                      "Loại vấn đề",
                                                      style: TextStyle(
                                                          fontSize: mFontSize,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Expanded(
                                                child: ListView.separated(
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                      int index) =>
                                                  const Divider(),
                                                  itemCount: problems.length,
                                                  itemBuilder: (context, index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          problem =
                                                          problems[index];
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: ListTile(
                                                        title: Text(
                                                          problems[index],
                                                          style: const TextStyle(
                                                              fontSize: mFontSize),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ))
                                          ],
                                        ));
                                  });
                            })
                  ],
                )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                        problem,
                        style: const TextStyle(
                            fontSize: mFontSize,
                            color: mPrimaryColor,
                            fontWeight: FontWeight.w600),
                    ),
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: mPrimaryColor,
                        ),
                        onPressed: () {
                          showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                    height: 300,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: const [
                                            Center(
                                                child: Text(
                                                  "Loại vấn đề",
                                                  style: TextStyle(
                                                      fontSize: mFontSize,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Expanded(
                                            child: ListView.separated(
                                              separatorBuilder:
                                                  (BuildContext context,
                                                  int index) =>
                                              const Divider(),
                                              itemCount: problems.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      problem =
                                                      problems[index];
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: ListTile(
                                                    title: Text(
                                                        problems[index],
                                                        style: const TextStyle(
                                                            fontSize:
                                                            mFontSize)),
                                                  ),
                                                );
                                              },
                                            ))
                                      ],
                                    ));
                              });
                        })
                  ],
                )),
            const SizedBox(
              height: space_height,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: TextFormField(
                minLines: 2,
                maxLines: 6,
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  hintText: 'Mô tả',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: mFontSize),
                ),
              ),
            ),
            const SizedBox(
              height: space_height,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 5, right: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Chọn hình ảnh", style: TextStyle(fontSize: mFontSize)),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: mPrimaryColor,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.camera,
                        color: Colors.white,
                        size: mFontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [test()],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                  future: customerApiProvider.customer.doc(customerApiProvider.user!.uid).get(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Send(snapshot.data!,size);
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            )
          ],
        ),
      ),
    );
  }
  Widget Send(DocumentSnapshot documentSnapshot, Size size){
    return SizedBox(
      width: size.width,
      height: 46,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(color: mPrimaryColor)),
        color: mPrimaryColor,
        textColor: Colors.white,
        child: const Text("Gửi", style: TextStyle(fontSize: subhead)),
        onPressed: () {
          setState(() {
            requestModel.photo = imageFile!.path;
            requestModel.senderName = documentSnapshot["name"];
            requestModel.description = descriptionController.text;
            requestModel.problemType = problem;
            requestModel.isActive = false;
            print(requestModel.senderName);
          });
          showLoaderDialog(context);
          Timer(const Duration(seconds: 2), () {
            customerApiProvider.requestSupport(requestModel,imageFile!);
            Navigator.pop(context);
            _showMaterialDialog();
          });
        },
      ),
    );
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
                  "Yêu cầu đã được gửi đi. Chúng tôi sẽ liên hệ với bạn sớm nhất!",
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
                          setState(() {
                            problem = '';
                            descriptionController.text = "";
                            imageFile = null as PickedFile;
                          });
                          Navigator.of(context, rootNavigator: true).pop();
                        }),
                  ])
            ],
          ),
        ));
  }

  _showErrorDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: Container(
            child: Column(
              children: [
                const Image(
                  width: 250,
                  height: 250,
                  image: AssetImage("assets/images/error.gif"),
                ),
                const Text(
                  "Thất bại",
                  style: TextStyle(fontSize: mFontSize, color: Colors.red),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Bạn vui lòng kiểm tra lại thông tin đăng kí nhé!",
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(color: Colors.black, fontSize: mFontSize),
                ),
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: mPrimaryColor)),
                    color: mPrimaryColor,
                    child: const Text('Quay lại',
                        style:
                        TextStyle(color: Colors.white, fontSize: 15)),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    })
              ],
            ),
          ),
        ));
  }

  void _openGallary(ImageSource source) async {
    final media = await picker.getImage(source: source);
    setState(() {
      imageFile = media!;
    });

    Navigator.of(context).pop();
  }

  Widget test() {
    if (imageFile == null) {
      return const Text("");
    } else {
      return Image.file(
        File(imageFile!.path),
        width: 60,
        height: 60,
      );
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text("Chọn ảnh hoặc video", style: TextStyle(fontSize: mFontSize)),
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
                  label: const Text("Thư viện", style: TextStyle(fontSize: mFontSize)))
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionController.dispose();
  }
}