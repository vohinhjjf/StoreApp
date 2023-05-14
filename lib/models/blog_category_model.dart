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
];
