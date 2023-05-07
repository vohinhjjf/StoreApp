import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../models/blog_model.dart';

class BlogViewPage extends StatefulWidget {
  const BlogViewPage({super.key, required this.blog});
  final BlogModel blog;

  @override
  State<BlogViewPage> createState() => _BlogViewPageState();
}

class _BlogViewPageState extends State<BlogViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: widget.blog.image,
              placeholder: (context, url) {
                return const CircularProgressIndicator();
              },
              errorWidget: (context, url, error) {
                return Center(
                  child: Image.asset('assets/images/img_not_available.jpeg'),
                );
              },
            ),
            Text(widget.blog.name),
            Text(widget.blog.category),
            Text(widget.blog.author),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.blog.time),
                Text(widget.blog.views.toString()),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 650,
              child: Markdown(data: widget.blog.content)),
          ],
        ),
      ),
    );
  }
}
