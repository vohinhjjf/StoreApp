import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_app/view/blog/blog_view/blog_view_screen.dart';

import '../../../Firebase/respository.dart';
import '../../../models/blog_model.dart';

class BlogCard extends StatelessWidget {
  BlogCard({super.key, required this.blog});
  final _repository = Repository();
  final BlogModel blog;
  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return BlogViewPage(
                blogId: blog.id,
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
          children: [
            CachedNetworkImage(
              imageUrl: blog.image,
              placeholder: (context, url) {
                return const CircularProgressIndicator();
              },
              errorWidget: (context, url, error) {
                return Center(
                  child: Image.asset('assets/images/blog_template.png'),
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
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
                        Text(blog.time),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_rounded,
                              color: Colors.green,
                            ),
                            Text(
                              blog.views.toString(),
                              style: const TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.favorite_rounded,
                              color: Colors.red,
                            ),
                            Text(
                              blog.likes.toString(),
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
