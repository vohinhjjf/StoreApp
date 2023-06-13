import 'package:flutter/material.dart';
import 'package:store_app/models/sticker_pack_model.dart';
import 'package:store_app/view/sticker/widget/sticker_info_widget.dart';

import '../../../Firebase/firebase_realtime_data_service.dart';

class StickerPackCard extends StatefulWidget {
  const StickerPackCard({
    Key? key,
    required this.stickerPack,
  }) : super(key: key);

  final StickerPackModel stickerPack;

  @override
  State<StickerPackCard> createState() => _StickerPackCardState();
}

class _StickerPackCardState extends State<StickerPackCard> {
  @override
  Widget build(BuildContext context) {
    final customerApiProvider = CustomerApiProvider();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return StickerPackInfoScreen(
                    stickerPack: widget.stickerPack,
                  );
                },
              ),
            );
          },
          title: Text(widget.stickerPack.name ?? ""),
          subtitle: const Text("eShop Sticker Pack"),
          leading: Image.network(
            widget.stickerPack.image,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset('assets/images/img_not_available.jpeg'),
          ),
          trailing: FutureBuilder(
              future: customerApiProvider.checkSticker(widget.stickerPack.id),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == null
                    ? const Text("+")
                    : addStickerPackButton(
                        snapshot.data as bool,
                      );
              }),
        ),
      ),
    );
  }

  Widget addStickerPackButton(
    bool isInstalled,
  ) {
    return IconButton(
      icon: Icon(
        isInstalled ? Icons.check : Icons.add,
      ),
      color: Colors.teal,
      tooltip: isInstalled ? 'Add Sticker' : 'Sticker is added',
      onPressed: () async {},
    );
  }
}
