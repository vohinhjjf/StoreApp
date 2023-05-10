import 'package:flutter/material.dart';

class BlogCategoryModel {
  final int id;
  final String title;
  final String imageUrl;

  const BlogCategoryModel({
    required this.id,
    required this.title,
    this.imageUrl = 'assets/images/blog_template.png',
  });
}

const List<BlogCategoryModel> categories = [
  BlogCategoryModel(
      id: 1,
      title: 'Đồ công nghệ',
      imageUrl: 'assets/images/c1_blog_category.jpg'),
  BlogCategoryModel(
      id: 2, title: 'Game', imageUrl: 'assets/images/c2_blog_category.jpg'),
  BlogCategoryModel(
      id: 3,
      title: 'Thủ thuật - Hướng dẫn',
      imageUrl: 'assets/images/c3_blog_category.jpg'),
  BlogCategoryModel(
      id: 4, title: 'Giải trí', imageUrl: 'assets/images/c4_blog_category.jpg'),
  BlogCategoryModel(
      id: 5, title: 'Coding', imageUrl: 'assets/images/c5_blog_category.jpg'),
  // BlogCategoryModel(id: 'c6', title: 'Exotic', imageUrl: 'assets/images/blog_template.png'),
  // BlogCategoryModel(id: 'c7', title: 'Breakfast', imageUrl: 'assets/images/blog_template.png'),
  // BlogCategoryModel(id: 'c8', title: 'Asian', imageUrl: 'assets/images/blog_template.png'),
  // BlogCategoryModel(id: 'c9', title: 'French', imageUrl: 'assets/images/blog_template.png'),
  // BlogCategoryModel(id: 'c10', title: 'Summer', imageUrl: 'assets/images/blog_template.png'),
];
