import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/view/sticker/widget/sticker_pack_card.dart';

import '../../Firebase/firebase_realtime_data_service.dart';
import '../../models/sticker_pack_model.dart';

class StickerPage extends StatefulWidget {
  const StickerPage({super.key});

  @override
  State<StickerPage> createState() => _StickerPageState();
}

class _StickerPageState extends State<StickerPage> {
  @override
  Widget build(BuildContext context) {
    final customerApiProvider = CustomerApiProvider();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade300,
        centerTitle: true,
        title: const Text(
          'Sticker Packs',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: const PageScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Flexible(
                child: CarouselSlider(
                  items: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: Image.asset('assets/images/sticker_banner1.png')
                                  .image,
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: Image.asset('assets/images/sticker_banner2.png')
                                  .image,
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image: Image.asset('assets/images/sticker_banner3.png')
                                  .image,
                              fit: BoxFit.cover)),
                    ),
                  ],
                  options: CarouselOptions(
                    height: 100,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 21 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: customerApiProvider.stickerPack.snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if ((snapshot.data?.docs.length ?? 0) > 0) {
                    List<StickerPackModel>? list = snapshot.data?.docs
                        .map((e) => StickerPackModel.fromMap(e))
                        .toList();
                    return SizedBox(
                      height: 500,
                      child: ListView.builder(
                        shrinkWrap: true, 
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) => StickerPackCard(
                          stickerPack: list![index],
                        ),
                        itemCount: snapshot.data?.docs.length,
                      ),
                    );
                  } else {
                    return Center(
                        child: Image.asset('assets/images/nothing_to_show.jpg'));
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
