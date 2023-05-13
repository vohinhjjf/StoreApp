import 'package:flutter/material.dart';

class CommentBox extends StatefulWidget {
  final Widget image;
  final TextEditingController controller;
  final BorderRadius inputRadius;
  final void Function() onSend, onImageRemoved;

  const CommentBox(
      {super.key,
      required this.image,
      required this.controller,
      required this.inputRadius,
      required this.onSend,
      required this.onImageRemoved});

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  Widget? image;

  @override
  void initState() {
    image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 1,
          color: Colors.grey[300],
          thickness: 1,
        ),
        const SizedBox(height: 20),
        if (image != null)
          _removable(
            context,
            _imageView(context),
          ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: const Color(0xffEDEDED),
              borderRadius: BorderRadius.circular(20)),
          child: Stack(children: <Widget>[
            TextFormField(
              controller: widget.controller,
              minLines: 1,
              maxLines: 25,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                fillColor: Color(0xffEDEDED),
                border: InputBorder.none,
                hintText: 'Hãy cho chúng tôi biết ý kiến của bạn...',
                hintStyle: TextStyle(color: Color(0xff606060), fontSize: 12),
                contentPadding: EdgeInsets.only(right: 90),
                filled: true,
              ),
              
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      color: Colors.blue,
                      onPressed: widget.onSend,
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: widget.onSend,
                    ),
                  ],
                ))
          ]),
        )
        // TextFormField(
        //   controller: widget.controller,
        //   maxLength: 500,
        //   minLines: 1,
        //   maxLines: 25,
        //   decoration: InputDecoration(
        //     suffixIcon: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         IconButton(
        //           icon: const Icon(
        //             Icons.image,
        //             color: Colors.blue,
        //           ),
        //           onPressed: widget.onSend,
        //         ),
        //         IconButton(
        //           icon: const Icon(
        //             Icons.send,
        //             color: Colors.blue,
        //           ),
        //           onPressed: widget.onSend,
        //         ),
        //       ],
        //     ),
        //     filled: true,
        //     border: OutlineInputBorder(
        //       borderSide: BorderSide.none,
        //       borderRadius: widget.inputRadius,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _removable(BuildContext context, Widget child) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        child,
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              image = null;
              widget.onImageRemoved();
            });
          },
        )
      ],
    );
  }

  Widget _imageView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: image,
      ),
    );
  }
}
