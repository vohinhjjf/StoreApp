import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/view/blog/blog_view/components/comment_section_widget.dart';

import '../../../../models/blog_model.dart';

class CommentList extends StatefulWidget {
  const CommentList({super.key, required this.blogId});
  final String blogId;

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  BlogModel? blog;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Blogs')
            .doc(widget.blogId)
            .snapshots()
            .map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
          blog = BlogModel.fromMap(snapshot.data()!);
        }),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Image.asset('assets/images/nothing_to_show.jpg'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          List<dynamic> commentList = blog!.comments
              .where((element) => element['parentId'] == null)
              .toList();
          commentList.sort((a, b) => a['time'].compareTo(b['time']));
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Bình luận bài viết',
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: commentList.length,
                      itemBuilder: (context, index) {
                        return CommentSection(
                          json: commentList.reversed.toList()[index],
                          isReplyView: false,
                          replyCount: blog!.comments
                              .where((i) =>
                                  i['parentId'] ==
                                  commentList.reversed.toList()[index]['id'])
                              .toList()
                              .length,
                        );
                      }),
                ]),
          );
        });
  }
}
