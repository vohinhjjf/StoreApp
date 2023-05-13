import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Firebase/respository.dart';
import '../../../../models/comment_model.dart';

class CommentSection extends StatelessWidget {
  CommentSection({super.key, required this.json});
  final Map<String, dynamic> json;
  final _repository = Repository();

  @override
  Widget build(BuildContext context) {
    final CommentModel comment = CommentModel.fromMap(json);
    DateTime commentTime = DateTime.parse(comment.time);
    String date = DateFormat('dd').format(commentTime);
    String moyear = DateFormat('MMM yyyy').format(commentTime);
    String time = DateFormat('kk:mm a').format(commentTime);
    String formattedDate = "${date}th $moyear $time";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: Image.network(comment.userImage).image,
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.78,
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                decoration: BoxDecoration(
                    color: const Color(0xffEDEDED),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(comment.userName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const Text(' • '),
                        Text(formattedDate,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Text(
                      comment.content,
                      maxLines: 25,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _repository.increaseCommentLikeCount(
                          comment.postId, json);
                    },
                    child: Row(
                      children: [
                        Text(
                          comment.likes.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        const Icon(Icons.favorite_rounded, color: Colors.blue)
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: const [
                        Text(
                          'Replies',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Icon(Icons.arrow_downward_rounded, color: Colors.blue)
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
