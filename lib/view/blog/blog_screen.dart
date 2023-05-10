import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/view/blog/components/blog_card_widget.dart';

import '../../Firebase/respository.dart';
import '../../models/blog_model.dart';
import 'blog_category/blog_category_sceen.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  bool _allFetched = false;
  bool _isLoading = false;
  List<BlogModel> _data = [];
  DocumentSnapshot? _lastDocument;
  static const PAGE_SIZE = 3;

  final _repository = Repository();
  late Query _query;

  int tag = 0;

  final ScrollController listScrollController = ScrollController();

  Icon customIcon = const Icon(
    Icons.search,
    color: Colors.blue,
  );
  Widget customSearchBar = const SizedBox();

  @override
  void initState() {
    super.initState();
    _fetchFirebaseData();
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const BlogCategoriesScreen();
                          },
                        ),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue)),
                    child:
                        const Icon(Icons.category_rounded, color: Colors.white),
                  ),
                  Expanded(child: customSearchBar),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (customIcon.icon == Icons.search) {
                          customIcon = const Icon(Icons.cancel);
                          customSearchBar = const ListTile(
                            leading: Icon(
                              Icons.search,
                              color: Colors.blue,
                              size: 28,
                            ),
                            title: TextField(
                              decoration: InputDecoration(
                                hintText: 'search blogs...',
                                hintStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          );
                        } else {
                          customIcon = const Icon(
                            Icons.search,
                            color: Colors.blue,
                          );
                          customSearchBar = const SizedBox();
                        }
                      });
                    },
                    icon: customIcon,
                  )
                ],
              ),
            ),
            Expanded(
              // child: StreamBuilder<QuerySnapshot>(
              //   stream:
              //       _repository.categoryFilter(tag).snapshots(),
              //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //     if (snapshot.hasError) {
              //       return const Text("Something went wrong");
              //     }
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(child: CircularProgressIndicator());
              //     }
              //     if ((snapshot.data?.docs.length ?? 0) > 0) {
              //       return ListView.builder(
              //         scrollDirection: Axis.vertical,
              //         shrinkWrap: true,
              //         padding: const EdgeInsets.all(10),
              //         itemBuilder: (context, index) => BlogCard(
              //           document: snapshot.data?.docs[index],
              //         ),
              //         itemCount: snapshot.data?.docs.length,
              //       );
              //     }
              //     return const Text('We are updating blogs');
              //   },
              // ),
              child: NotificationListener<ScrollEndNotification>(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == _data.length) {
                      return const SizedBox(
                        key: ValueKey('Loader'),
                        width: double.infinity,
                        height: 60,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final item = _data[index];
                    return BlogCard(
                      blog: item,
                    );
                  },
                  itemCount: _data.length + (_allFetched ? 0 : 1),
                ),
                onNotification: (scrollEnd) {
                  if (scrollEnd.metrics.atEdge &&
                      scrollEnd.metrics.pixels > 0) {
                    _fetchFirebaseData();
                  }
                  return true;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchFirebaseData() async {
    _query = _repository.categoryFilter(tag);
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    if (_lastDocument != null) {
      _query = _query.startAfterDocument(_lastDocument!).limit(PAGE_SIZE);
    } else {
      _query = _query.limit(PAGE_SIZE);
    }

    final List<BlogModel> pagedData = await _query.get().then((value) {
      if (value.docs.isNotEmpty) {
        _lastDocument = value.docs.last;
      } else {
        _lastDocument = null;
      }
      return value.docs
          .map((e) => BlogModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });

    setState(() {
      _data.addAll(pagedData);
      if (pagedData.length < PAGE_SIZE) {
        _allFetched = true;
      }
      _isLoading = false;
    });
  }
}
