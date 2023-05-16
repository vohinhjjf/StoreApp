import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Firebase/respository.dart';
import '../../../../models/comment_model.dart';

class CommentBox extends StatefulWidget {
  final TextEditingController controller;
  final BorderRadius inputRadius;
  final String blogId;
  final String userName;
  final String userImage;
  String? parentId;

  CommentBox(
      {super.key,
      required this.controller,
      required this.inputRadius,
      required this.blogId,
      required this.userName,
      required this.userImage,
      this.parentId});

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  Widget? image;
  User? user = FirebaseAuth.instance.currentUser;
  final _repository = Repository();
  File? imageFile;
  String? downloadUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        if (image != null)
          _removable(
            context,
            _imageView(context),
          ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: const Color(0xffEDEDED),
              borderRadius: BorderRadius.circular(20)),
          child: Stack(children: <Widget>[
            TextFormField(
              controller: widget.controller,
              minLines: 1,
              maxLines: 25,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                fillColor: Color(0xffEDEDED),
                border: InputBorder.none,
                hintText: 'Hãy cho chúng tôi biết ý kiến của bạn...',
                hintStyle: TextStyle(color: Color(0xff606060), fontSize: 12),
                contentPadding: EdgeInsets.only(right: 90),
                filled: true,
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      color: Colors.blue,
                      onPressed: () {
                        pickImage();
                      },
                    ),
                    IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          if (widget.controller.text.isNotEmpty) {
                            CommentModel comment = CommentModel(
                                id: DateTime.now().toString(),
                                userId: user!.uid,
                                content: widget.controller.text,
                                postId: widget.blogId,
                                time: DateTime.now().toString(),
                                userName: widget.userName,
                                userImage: widget.userImage,
                                likes: 0,
                                replies: [],
                                image: downloadUrl,
                                parentId: widget.parentId);
                            FocusManager.instance.primaryFocus?.unfocus();

                            _repository.addComment(
                                widget.blogId, comment.toMap());
                            widget.controller.clear();
                            if (imageFile == null) {
                              setState(() {
                                downloadUrl = null;
                              });
                            } else {
                              setState(() {
                                imageFile = null;
                                image = null;
                              });
                            }
                          }
                        }),
                  ],
                ))
          ]),
        )
      ],
    );
  }

  Widget _removable(BuildContext context, Widget child) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          child,
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                image = null;
                imageFile = null;
              });
            },
          )
        ],
      ),
    );
  }

  Widget _imageView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: image,
      ),
    );
  }

  uploadImage() async {
    if (imageFile != null) {
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("user/${user!.uid}/comments/${DateTime.now()}");
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile!);
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
      setState(() {
        imageFile = imageTemporary;
        this.image = Image.file(imageFile!, width: 96, height: 96);
      });
      uploadImage();
      print(image.path);
    } on PlatformException catch (e) {
      print('Failed to pick image');
    }
  }
}
