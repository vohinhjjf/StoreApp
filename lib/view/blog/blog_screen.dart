import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:store_app/constant.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade300,
        centerTitle: true,
        title: const Text(
          'Blogs',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: mPrimaryColor),
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
                stream: _repository.categoryFilter(tag),
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
                        itemCount: snapshot.data?.docs.length);
                  }
                  return const Text('We are updating blogs');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
