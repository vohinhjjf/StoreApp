import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/models/comment_model.dart';

import '../../../Firebase/respository.dart';
import '../../../constant.dart';
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
  TextEditingController commentsController = TextEditingController();
  String userName = '';
  String userImage = '';
  File? image;
  String? downloadUrl;
  Image? i = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade300,
        centerTitle: true,
        title: const Text(
          'Blog Detail',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: mPrimaryColor),
      ),
      body: StreamBuilder(
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
          return Stack(children: [
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              userName = snapshot.data!.name;
                              userImage = snapshot.data!.image;
                              return Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'Bạn có thích bài viết này không?',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
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
                                            ? 'Bạn và những người khác đã thích bài viết này : ${blog!.likes.toString()} lượt thích'
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
                                          commentList.reversed.toList()[index]
                                              ['id'])
                                      .toList()
                                      .length,
                                );
                              }),
                        ]),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
            user != null
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: CommentBox(
                      image: image != null
                          ? Image.file(
                              image!,
                              height: 96,
                              width: 96,
                            )
                          : i,
                      controller: commentsController,
                      onImageRemoved: () {
                        setState(() {
                          if (image != null) {
                            image = null;
                          }
                        });
                      },
                      onSend: () {
                        if (commentsController.text.isNotEmpty) {
                          CommentModel comment = CommentModel(
                              id: DateTime.now().toString(),
                              userId: user!.uid,
                              content: commentsController.text,
                              postId: widget.blogId,
                              time: DateTime.now().toString(),
                              userName: userName,
                              userImage: userImage,
                              likes: 0,
                              replies: [],
                              image: downloadUrl);
                          FocusManager.instance.primaryFocus?.unfocus();

                          _repository.addComment(
                              widget.blogId, comment.toMap());
                          commentsController.clear();
                          if (image != null) {
                            setState(() {
                              image = null;
                              downloadUrl = null;
                            });
                          }
                        }
                      },
                      inputRadius: BorderRadius.circular(16),
                      onPickImage: () {
                        pickImage();
                      },
                    ),
                  )
                : const SizedBox(),
          ]);
        },
      ),
    );
  }

  uploadImage() async {
    if (image != null) {
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("user/${user!.uid}/comments/${DateTime.now()}");
      UploadTask uploadTask = firebaseStorageRef.putFile(image!);
      //repository.updateAvatar(prefs.get('ID').toString(), url)
      TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);
      setState(
          () async => downloadUrl = await storageSnapshot.ref.getDownloadURL());
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
      uploadImage();
      print(image.path);
    } on PlatformException catch (e) {
      print('Failed to pick image');
    }
  }
}
