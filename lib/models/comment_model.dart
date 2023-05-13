class CommentModel {
  late String id;
  late String userId;
  late String userName;
  late String userImage;
  late String postId;
  late String content;
  String? image;
  late String time;
  int likes;
  List<CommentModel>? replies;

  CommentModel(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.userImage,
      required this.postId,
      required this.content,
      this.image,
      this.likes = 0,
      this.replies,
      required this.time});

  factory CommentModel.fromMap(Map<String, dynamic> json) {
    CommentModel commentModel = CommentModel(
      id: json["id"],
      userId: json["userId"],
      userName: json["userName"],
      userImage: json["userImage"],
      postId: json["postId"],
      content: json["content"],
      image: json["image"],
      time: json["time"],
      likes: json['likes'],
     
    );

    return commentModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'postId': postId,
      'content': content,
      'image': image,
      'time': time
    };
  }
}
