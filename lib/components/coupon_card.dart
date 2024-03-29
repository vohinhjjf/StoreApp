import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_svg/svg.dart';
import 'package:store_app/constant.dart';

class CouponCard extends StatelessWidget {
  final String name;
  final String voucherId;
  final double maxDiscount;
  final bool freeship;
  final bool check;
  final int time;
  final Color startColor;
  final Color endColor;
  final double _borderRadius = 24;
  final Function(bool?)? cb_voucher;
  final Function() onclick;

   const CouponCard(
      {Key? key,
        required this.name,
        required this.voucherId,
        required this.maxDiscount,
        required this.freeship,
        required this.time,
        required this.endColor,
        required this.startColor,
        required this.onclick,
        this.cb_voucher, required this.check,}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Stack(
          children: <Widget>[
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                gradient: LinearGradient(
                    colors: [endColor,startColor],
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
              child: InkWell(
                onTap: onclick,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: CustomPaint(
                size: const Size(100, 150),
                painter:
                    CustomCardShapePainter(_borderRadius, startColor, endColor),
              ),
            ),
            Positioned.fill(
              child: Row(
                children: <Widget>[
                  freeship == false? Expanded(
                    flex: 1,
                    child: SvgPicture.asset(
                      "assets/images/present.svg",
                      height: 70,
                    ),
                  ):Expanded(
                    flex: 1,
                    child: Image.asset(
                      "assets/images/freeship.png",
                      height: 70,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        //const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Text(
                                'Hạn sử dụng: ${time} ngày',
                                style: const TextStyle(
                                  fontSize: footnote,
                                ),
                              ),
                            ),
                            Expanded(
                              //flex: 1,
                              child: Checkbox(
                                checkColor: Colors.white,
                                activeColor: startColor,
                                onChanged: cb_voucher,
                                value: check,
                              ),
                            )
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
