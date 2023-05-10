import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

import '../../components/blog_list_view.dart';

class CategoryItem extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;

  const CategoryItem(
      {Key? key, required this.id, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return BlogListView(tag: id);
            },
          ),
        )
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset(imageUrl).image,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.blue),
        child: Align(
          alignment: Alignment.topLeft,
          child: BorderedText(
            strokeWidth: 4.0,
            strokeColor: Colors.white,
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
