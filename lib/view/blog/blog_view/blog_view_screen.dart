import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../Firebase/respository.dart';
import '../../../models/blog_model.dart';
import '../../../models/customer_model.dart';
import '../../login/welcome_screen.dart';
import 'components/comment_box_widget.dart';
import 'components/comment_section_widget.dart';

class BlogViewPage extends StatefulWidget {
  const BlogViewPage({super.key, required this.blogId});
  final String blogId;

  @override
  State<BlogViewPage> createState() => _BlogViewPageState();
}

class _BlogViewPageState extends State<BlogViewPage> {
  final _repository = Repository();
  late bool isPostLiked = true;
  User? user = FirebaseAuth.instance.currentUser;
  BlogModel? blog;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Blogs')
              .doc(widget.blogId)
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  child: CachedNetworkImage(
                    imageUrl: blog!.image,
                    placeholder: (context, url) {
                      return const CircularProgressIndicator();
                    },
                    errorWidget: (context, url, error) {
                      return Center(
                        child: Image.asset('assets/images/blog_template.png'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blog!.name,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Danh mục: ${blog!.category}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Tác giả: ${blog!.author}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Ngày đăng: ${blog!.time}',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Lượt xem: ${blog!.views.toString()}',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Markdown(
                    data: blog!.content,
                    shrinkWrap: true,
                    selectable: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: user != null
                      ? FutureBuilder(
                          future: _repository.getUserById(user!.uid),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<CustomerModel?> snapshot,
                          ) {
                            if (snapshot.hasError) {
                              return const SizedBox();
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            return Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Bạn có thích bài viết này không?',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 18),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        OutlinedButton(
                                            onPressed: () {
                                              if (!snapshot.data!.likeBkogs
                                                  .contains(widget.blogId)) {
                                                _repository.addBlogLiked(
                                                    widget.blogId);
                                                _repository
                                                    .increaseBlogLikeCount(
                                                        widget.blogId);
                                              } else {
                                                _repository.removeBlogLiked(
                                                    widget.blogId);
                                                _repository
                                                    .decreseBlogLikeCount(
                                                        widget.blogId);
                                              }
                                            },
                                            child: snapshot.data!.likeBkogs
                                                    .contains(widget.blogId)
                                                ? const Icon(
                                                    Icons.thumb_up_rounded,
                                                    color: Colors.blue,
                                                  )
                                                : const Icon(
                                                    Icons.thumb_up_outlined,
                                                  )),
                                      ],
                                    ),
                                    Text(
                                      snapshot.data!.likeBkogs
                                              .contains(widget.blogId)
                                          ? 'Bạn và ${blog!.likes.toString()} người khác đã thích bài viết này'
                                          : '${blog!.likes.toString()} người khác đã thích bài viết này',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        )
                      : TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return WelcomeScreen();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'Bạn cần đăng nhập để like và bình luận bài viết này',
                            style: TextStyle(
                              color: Colors.orange,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        user != null
                            ? CommentBox(
                                image: Image.asset(
                                  "assets/images/nothing_to_show.jpg",
                                  height: 64,
                                  width: 64,
                                ),
                                controller: TextEditingController(),
                                onImageRemoved: () {
                                  //on image removed
                                },
                                onSend: () {
                                  //on send button pressed
                                },
                                inputRadius: BorderRadius.circular(16),
                              )
                            : const SizedBox(),
                        const Text(
                          'Bình luận bài viết',
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                        CommentSection(),
                        CommentSection(),
                        CommentSection(),
                      ]),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
