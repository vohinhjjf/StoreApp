import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/view/blog/blog_view/blog_view_scrren.dart';

import '../../../Firebase/respository.dart';
import '../../../models/blog_model.dart';

class BlogCard extends StatelessWidget {
  BlogCard({super.key, required this.document});
  final _repository = Repository();
  final DocumentSnapshot? document;
  @override
  Widget build(context) {
    BlogModel blog = BlogModel.fromDocument(document!);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return BlogViewPage(
                blog: blog,
              );
            },
          ),
        );
        _repository.updateBlogViewCount(blog.id);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: blog.image,
              placeholder: (context, url) {
                return const CircularProgressIndicator();
              },
              errorWidget: (context, url, error) {
                return Center(
                  child: Image.asset('assets/images/img_not_available.jpeg'),
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              blog.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              blog.short,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Icons.calendar_month_rounded),
                    Text(blog.time),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_rounded),
                    Text(blog.views.toString()),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite_border_rounded),
                    Text(blog.likes.toString()),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
