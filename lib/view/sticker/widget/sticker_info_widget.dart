import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/sticker_pack_model.dart';

import '../../../Firebase/firebase_realtime_data_service.dart';

class StickerPackInfoScreen extends StatefulWidget {
  const StickerPackInfoScreen({Key? key, required this.stickerPack})
      : super(key: key);
  final StickerPackModel stickerPack;

  @override
  State<StickerPackInfoScreen> createState() => _StickerPackInfoScreenState();
}

class _StickerPackInfoScreenState extends State<StickerPackInfoScreen> {
  Future<void> addStickerPack() async {}

  @override
  Widget build(BuildContext context) {
    final customerApiProvider = CustomerApiProvider();

    List<Widget> fakeBottomButtons = [];
    fakeBottomButtons.add(
      Container(
        height: 50.0,
      ),
    );

    Widget depInstallWidget;
    if (true) {
      depInstallWidget = const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "Sticker Added",
          style: TextStyle(
              color: Colors.green, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade300,
        centerTitle: true,
       
        title: Text("${widget.stickerPack.name} Stickers", style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(
                  widget.stickerPack.image,
                  width: 100,
                  height: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.stickerPack.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Text(
                      'eShop Sticker Pack',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                    depInstallWidget,
                  ],
                ),
              )
            ],
          ),
          StreamBuilder(
              stream: customerApiProvider.stickerPack
                  .doc(widget.stickerPack.id)
                  .collection('Stickers')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Image.asset('assets/images/nothing_to_show.jpg'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: FadeInImage(
                            placeholder: const AssetImage(
                                "assets/images/img_not_available.jpeg"),
                            image: Image.network(
                              snapshot.data!.docs[index]['image'],
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                      'assets/images/img_not_available.jpeg'),
                            ).image,
                          ));
                    },
                  ),
                );
              })
        ],
      ),
      persistentFooterButtons: fakeBottomButtons,
    );
  }
}
