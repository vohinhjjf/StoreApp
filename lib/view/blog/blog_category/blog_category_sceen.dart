import 'package:flutter/material.dart';

import '../../../constant.dart';
import '../../../models/blog_category_model.dart';
import 'components/category_item_widget.dart';

class BlogCategoriesScreen extends StatefulWidget {
  const BlogCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<BlogCategoriesScreen> createState() => _BlogCategoriesScreenState();
}

class _BlogCategoriesScreenState extends State<BlogCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade300,
        centerTitle: true,
        title: const Text(
          'Blogs Category',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: mPrimaryColor),
      ),
      body: GridView(
        padding: const EdgeInsets.all(25.0),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          mainAxisExtent: 300,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: categories
            .map(
              (categoryData) => CategoryItem(
                id: categoryData.id,
                title: categoryData.title,
                imageUrl: categoryData.imageUrl,
              ),
            )
            .toList(),
      ),
    );
  }
}
