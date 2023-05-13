import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_app/view/blog/blog_view/components/comment_section_widget.dart';
import 'package:intl/intl.dart';

import '../../../../Firebase/respository.dart';
import '../../../../constant.dart';
import '../../../../models/blog_model.dart';
import '../../../../models/comment_model.dart';
import 'comment_box_widget.dart';

class CommentReplyPage extends StatefulWidget {
  const CommentReplyPage({super.key, required this.comment});
  final CommentModel comment;

  @override
  State<CommentReplyPage> createState() => _CommentReplyPageState();
}

class _CommentReplyPageState extends State<CommentReplyPage> {
  final _repository = Repository();
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController commentsController = TextEditingController();
  BlogModel? blog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue.shade300,
          centerTitle: true,
          title: const Text(
            'Replies',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: mPrimaryColor),
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Blogs')
                    .doc(widget.comment.postId)
                    .snapshots()
                    .map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
                  blog = BlogModel.fromMap(snapshot.data()!);
                }),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  List<dynamic> commentList = blog!.comments
                      .where((i) => i['parentId'] == widget.comment.id)
                      .toList();
                  commentList.sort((a, b) => a['time'].compareTo(b['time']));
                  return Column(
                    children: [
                      CommentSection(
                        json: widget.comment.toMap(),
                        isReplyView: true,
                        replyCount: 0,
                      ),
                      user != null
                          ? CommentBox(
                              image: Image.asset(
                                "assets/images/nothing_to_show.jpg",
                                height: 64,
                                width: 64,
                              ),
                              controller: commentsController,
                              onImageRemoved: () {
                                //on image removed
                              },
                              onSend: () {
                                if (commentsController.text.isNotEmpty) {
                                  CommentModel comment = CommentModel(
                                      id: DateTime.now().toString(),
                                      userId: user!.uid,
                                      content: commentsController.text,
                                      postId: widget.comment.postId,
                                      time: DateTime.now().toString(),
                                      userName: widget.comment.userName,
                                      userImage: widget.comment.userImage,
                                      likes: 0,
                                      replies: [],
                                      parentId: widget.comment.id);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  _repository.addComment(
                                      widget.comment.postId, comment.toMap());
                                  commentsController.clear();
                                }
                              },
                              inputRadius: BorderRadius.circular(16),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: commentList.length,
                          itemBuilder: (context, index) {
                            return CommentSection(
                              json: commentList.reversed.toList()[index],
                              isReplyView: true,
                              replyCount: 0,
                            );
                          }),
                    ],
                  );
                }),
          ),
        ));
  }
}
