import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constant.dart';
import '../../mini_game_module/view/game_screen.dart';
import '../blog/blog_screen.dart';

class ExtensionsScreen extends StatefulWidget {
  ExtensionsScreen({super.key});
  @override
  _ExtensionsScreenState createState() => _ExtensionsScreenState();
}

class _ExtensionsScreenState extends State<ExtensionsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade300,
        leading: IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {}),
        leadingWidth: 30,
        //centerTitle: true,
        title: TextField(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(8),
            //focusedBorder: border,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            isDense: true,
            hintText: "Tìm kiếm",
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onTap: () {},
        ),
        actions: [
          IconButton(
            iconSize: 28,
            onPressed: () async {},
            icon: const Icon(
              Icons.qr_code_2,
            ),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Tiện ích cho bạn',
              style: TextStyle(
                fontSize: mFontTitle,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            GridView(
                padding: const EdgeInsets.all(10.0),
                shrinkWrap: true,
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 15,
                ),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const BlogScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange.withAlpha(30)),
                          child: const Center(
                            child: Icon(
                              Icons.newspaper_rounded,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Blogs',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          /*Navigator.of(context).push(MaterialPageRoute (
                            builder: (BuildContext context) => ProductListWidget('Điện thoại','Điện Thoại', widget.id),
                          ));*/
                        },
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                   GameScreen(),
                            ),
                          ),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green.withAlpha(30)),
                            child: Center(
                              child: Icon(
                                MdiIcons.gamepadVariant,
                                color: Colors.green.shade400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Game',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          /*Navigator.of(context).push(MaterialPageRoute (
                            builder: (BuildContext context) => ProductListWidget('Điện thoại','Điện Thoại', widget.id),
                          ));*/
                        },
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purpleAccent.withAlpha(30)),
                          child: const Center(
                            child: Icon(
                              MdiIcons.stickerEmoji,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Sticker',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          /*Navigator.of(context).push(MaterialPageRoute (
                            builder: (BuildContext context) => ProductListWidget('Điện thoại','Điện Thoại', widget.id),
                          ));*/
                        },
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withAlpha(30)),
                          child: const Center(
                            child: Icon(
                              MdiIcons.weatherCloudy,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Thời tiết',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          /*Navigator.of(context).push(MaterialPageRoute (
                            builder: (BuildContext context) => ProductListWidget('Điện thoại','Điện Thoại', widget.id),
                          ));*/
                        },
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withAlpha(30)),
                          child: const Center(
                            child: Icon(
                              MdiIcons.phone,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Nạp tiền ĐT',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          /*Navigator.of(context).push(MaterialPageRoute (
                            builder: (BuildContext context) => ProductListWidget('Điện thoại','Điện Thoại', widget.id),
                          ));*/
                        },
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.pink.withAlpha(30)),
                          child: const Center(
                            child: Icon(
                              MdiIcons.video,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Mua vé\nxem phim',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          /*Navigator.of(context).push(MaterialPageRoute (
                            builder: (BuildContext context) => ProductListWidget('Điện thoại','Điện Thoại', widget.id),
                          ));*/
                        },
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.greenAccent.withAlpha(30)),
                          child: const Center(
                            child: Icon(
                              MdiIcons.airplane,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Vé máy bay',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          /*Navigator.of(context).push(MaterialPageRoute (
                            builder: (BuildContext context) => ProductListWidget('Điện thoại','Điện Thoại', widget.id),
                          ));*/
                        },
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepPurpleAccent.withAlpha(30)),
                          child: const Center(
                            child: Icon(
                              Icons.location_on_rounded,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Tìm quanh\nđây',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ]),
            Container(
              height: 7,
              color: Colors.grey.shade200,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withAlpha(30)),
                  child: Center(
                    child: Icon(
                      MdiIcons.gamepadVariant,
                      color: Colors.green.shade400,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Khám phá game hay',
                  style: TextStyle(
                    fontSize: mFontListTile,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    setState(() {});
                  },
                  height: 160,
                  minWidth: 160,
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/sudoku.png',
                      //color: darkGrey,
                      height: 160),
                ),
                MaterialButton(
                    onPressed: () {
                      setState(() {});
                    },
                    height: 160,
                    minWidth: 160,
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/tien_len.jpg',
                        //color: darkGrey,
                        height: 155))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
