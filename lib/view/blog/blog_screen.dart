import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:store_app/view/blog/components/blog_card_widget.dart';

import '../../Firebase/respository.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final _repository = Repository();
  int tag = 0;
  final List<String> options = [
    'Tất cả', //0
    'Đồ công nghệ', //1,
    'Game', //2
    'Thủ thuật - Hướng dẫn', //3
    'Giải trí', //4
    'Coding', //5
  ];

  final ScrollController listScrollController = ScrollController();
  int _limit = 2;
  final int _limitIncrement = 2;

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Blogs',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ChipsChoice<int>.single(
                  value: tag,
                  onChanged: (val) {
                    setState(() {
                      tag = val;
                    });
                  },
                  choiceItems: C2Choice.listFrom<int, String>(
                    source: options,
                    value: (i, v) => i,
                    label: (i, v) => v,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _repository.categoryFilter(tag).limit(_limit).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if ((snapshot.data?.docs.length ?? 0) > 0) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) => BlogCard(
                        document: snapshot.data?.docs[index],
                      ),
                      itemCount: snapshot.data?.docs.length,
                      controller: listScrollController,
                    );
                  }
                  return const Text('We are updating blogs');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }
}
