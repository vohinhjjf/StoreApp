import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  late String id;
  late String name;
  late String category;
  late String author;
  late String time;
  late String short;
  late String image;
  late String content;
  late int likes;
  late List comments;
  late int views;

  BlogModel();

  factory BlogModel.fromDocument(DocumentSnapshot doc) {
    BlogModel blog = BlogModel();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    blog.id = doc.id;
    blog.name = data["name"];
    blog.author = data["Author"];
    blog.time = data["time"];
    blog.short = data["short"];
    blog.image = data["image"];
    blog.category = data["category"];
    blog.content = data["content"];
    blog.views = data["views"];
    blog.likes = data["likes"];
    blog.comments = data["comments"];
    return blog;
  }
}
