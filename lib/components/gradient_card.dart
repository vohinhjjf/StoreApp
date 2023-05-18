import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_svg/svg.dart';
import 'package:store_app/constant.dart';

class GradientCard extends StatelessWidget {
  final String name;
  final double maxDiscount;
  final bool freeship;
  final int time;
  final Color startColor;
  final Color endColor;
  final double _borderRadius = 24;
  final String option;
  final Function() onclick, onExchanged;
  final int? point;

  const GradientCard(
      {Key? key,
      required this.name,
      required this.maxDiscount,
      required this.freeship,
      required this.time,
      required this.endColor,
      required this.startColor,
      required this.option,
      required this.onclick,
      this.point, required this.onExchanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: GestureDetector(
          onTap: () {},
          child: Stack(
            children: <Widget>[
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  gradient: LinearGradient(
                      colors: [startColor, endColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  boxShadow: [
                    BoxShadow(
                      color: endColor,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
              ),
              option == "Mới nhất"
                  ? Positioned(
                      right: 0,
                      bottom: 0,
                      top: 40,
                      child: CustomPaint(
                        size: const Size(100, 150),
                        painter: CustomCardShapePainter(
                            _borderRadius, startColor, endColor),
                      ),
                    )
                  : Container(),
              Positioned.fill(
                child: Row(
                  children: <Widget>[
                    freeship == false
                        ? Expanded(
                            flex: 2,
                            child: SvgPicture.asset(
                              "assets/images/present.svg",
                              height: 70,
                            ),
                          )
                        : Expanded(
                            flex: 2,
                            child: Image.asset(
                              "assets/images/freeship.png",
                              height: 70,
                            ),
                          ),
                    Expanded(
                      flex: option == "Mới nhất" ? 4 : 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: mFontListTile,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Tối đa ${maxDiscount}k',
                            style: const TextStyle(
                              fontSize: footnote,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Flexible(
                                flex: 3,
                                child: Text(
                                  'Hạn sử dụng: $time ngày',
                                  style: const TextStyle(
                                    fontSize: footnote,
                                  ),
                                ),
                              ),
                              option == "Mới nhất"
                                  ? Expanded(
                                      //flex: 1,
                                      child: point == 0
                                          ? TextButton(
                                              onPressed: onclick,
                                              child: Text(
                                                "Lưu",
                                                style: TextStyle(
                                                    color: Colors.amber[900],
                                                    fontSize: mFontTitle,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )
                                          : TextButton(
                                              onPressed: onExchanged,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    point.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: mFontTitle,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const Icon(Icons.diamond,
                                                      color: Colors.blue, size: 14),
                                                ],
                                              ),
                                            ),
                                    )
                                  : Container()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        const Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
