import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/components/gradient_card.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/campaign_model.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  final customerApiProvider = CustomerApiProvider();
  late TabController _controller;
  User? user = FirebaseAuth.instance.currentUser;
  bool isExchanged = false;
  int point = 0;

  List<Widget> list = [
    const Tab(
      child: Text(
        "Mới nhất",
        style: TextStyle(color: Colors.white, fontSize: subhead),
      ),
    ),
    const Tab(
      child: Text(
        "Đã đổi",
        style: TextStyle(color: Colors.white, fontSize: subhead),
      ),
    ),
  ];
  @override
  void initState() {
    super.initState();
    _controller =
        TabController(length: list.length, vsync: this, initialIndex: 0);
    /*_controller.addListener(() {
      setState(() {
        _controller =
            TabController(length: list.length, vsync: this, initialIndex: 0);
        print("Selected Index: ${_controller.index}");
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          backgroundColor: Colors.lightBlue.shade300,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelStyle: const TextStyle(
              fontSize: mFontSize,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ), //For Selected tab
            unselectedLabelStyle:
                const TextStyle(fontSize: 16, color: Colors.white),
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
            controller: _controller,
            tabs: list,
          ),
          title: const Text(
            'Mã giảm giá',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: mFontTitle),
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            StreamBuilder(
              stream: customerApiProvider.voucher
                  .where("active", isEqualTo: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.2,
                          ),
                          const Text("Hiện tại không có khuyến mãi nào!",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: mFontSize)),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SvgPicture.asset(
                            "assets/images/empty.svg",
                            height: size.height * 0.3,
                          ),
                        ],
                      ),
                    );
                  }
                  return buildList(snapshot.data!, "Mới nhất");
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            FutureBuilder(
              future: customerApiProvider.getVoucherSaved(),
              builder: (context, AsyncSnapshot<List<CampaignModel>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.2,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.0),
                            child: Text(
                                "Hãy dùng điểm để đổi lấy các khuyến mãi giá trị nào !",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: mFontSize)),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SvgPicture.asset(
                            "assets/images/empty.svg",
                            height: size.height * 0.3,
                          ),
                        ],
                      ),
                    );
                  }
                  return buildListCollection(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildList(QuerySnapshot querySnapshot, String option) {
    return ListView(
        children: querySnapshot.docs.map((DocumentSnapshot document) {
      return buildData(document, option);
    }).toList());
  }

  Widget buildData(DocumentSnapshot document, String option) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GradientCard(
        name: document['name'],
        maxDiscount: document['maxDiscount'] * 1.0,
        freeship: document['freeship'],
        time: document['time'],
        startColor: document['exchangedPoint'] == 0
            ? const Color(0xfffdfcfb)
            : const Color(0xff01bfff),
        endColor: document['exchangedPoint'] == 0
            ? const Color(0xffe2d1c3)
            : const Color(0xff426fff),
        option: option,
        onclick: () {
          customerApiProvider.checkVoucher(document.id).then((value) {
            if (value) {
              notificationDialog(context);
            } else {
              customerApiProvider
                  .saveVoucher(document.id)
                  .then((value) => successDialog(context));
            }
          });
          print("click");
        },
        point: document['exchangedPoint'],
        onExchanged: () {
          setState(() {
            pointDialog(context, document.id, document['exchangedPoint']);
          });
          print("onExchanged");
        },
      ),
    );
  }

  Widget buildListCollection(List<CampaignModel> listCampaign) {
    return ListView.builder(
      itemCount: listCampaign.length,
      itemBuilder: (context, index) {
        return buildDataCollection(listCampaign[index]);
      },
    );
  }

  Widget buildDataCollection(CampaignModel campaignModel) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GradientCard(
          name: campaignModel.name,
          maxDiscount: campaignModel.maxDiscount,
          freeship: campaignModel.freeship,
          time: campaignModel.time,
          startColor: const Color(0xfffdfcfb),
          endColor: const Color(0xffe2d1c3),
          option: "Đã đổi",
          onclick: () {},
          onExchanged: () {},
        ));
  }

  successDialog(BuildContext context) {
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
                Icon(
                  MdiIcons.checkboxMarkedCircle,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Lưu thành công!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  notificationDialog(BuildContext context) {
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
                Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Bạn đã có voucher này rồi!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  pointDialog(BuildContext context, String id, int point) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.5),
            title: Column(
              children: [
                const Text(
                  'Điểm của bạn:',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user!.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text(
                          'Đã có lỗi xảy ra!',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (snapshot.data
                                        as DocumentSnapshot)['redeemPoint']
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                              const Icon(Icons.diamond, color: Colors.blue),
                            ],
                          ),
                          (snapshot.data as DocumentSnapshot)['redeemPoint'] >=
                                  point
                              ? OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      customerApiProvider.exchangeVoucher(
                                          id, point);
                                    });
                                    Navigator.of(context).pop();
                                    const snackBar = SnackBar(
                                      content: Text('Đổi điểm thành công'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  child: const Text(
                                    'Đổi điểm',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Bạn không đủ điểm',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                        ],
                      );
                    }),
              ],
            ),
          );
        }).then((val) {});
  }
}
