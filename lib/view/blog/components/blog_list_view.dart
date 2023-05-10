import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Firebase/respository.dart';
import '../../../constant.dart';
import '../../../models/blog_model.dart';
import 'blog_card_widget.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({super.key, required this.tag});
  final int tag;

  @override
  State<BlogListView> createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView> {
  bool _allFetched = false;

  bool _isLoading = false;

  final List<BlogModel> _data = [];

  DocumentSnapshot? _lastDocument;

  int PAGE_SIZE = 3;

  final _repository = Repository();

  late Query _query;

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
            if (scrollEnd.metrics.atEdge && scrollEnd.metrics.pixels > 0) {
              _fetchFirebaseData();
            }
            return true;
          },
        ),
      ),
    );
  }

  Future<void> _fetchFirebaseData() async {
    _query = _repository.categoryFilter(widget.tag);
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
