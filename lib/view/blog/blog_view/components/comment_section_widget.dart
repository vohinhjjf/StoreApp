import 'package:flutter/material.dart';

import '../../../../models/comment_model.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key, required this.json});
  final Map<String, dynamic> json;

  @override
  Widget build(BuildContext context) {
    final CommentModel comment = CommentModel.fromMap(json);
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
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Text(' • '),
                    Text(comment.time,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Text(
                  comment.content,
                  maxLines: 25,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
