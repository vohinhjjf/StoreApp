import 'package:flutter/material.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage:
                Image.asset('assets/images/nothing_to_show.jpg').image,
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
              children: [
                Row(
                  children: [
                    Text('Trung Nguyên', style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text(' • '),
                    Text('14/20/03', style: TextStyle(fontSize: 12 ,color: Colors.grey)),
                  ],
                ),
                Text(
                  'comment content dhifhiasdfsa sadsa adasdasdasd\ndsfsdfsdfsdfdsf \ndfsdfdsfsdfsdfer',
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
