import 'dart:async';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constant.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentPage = 1;

List<Widget> _pages=[
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/shopping (2).webp')),
      const Text(
        'Mua sắm online từ chiếc điện thoại của bạn',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/sale.webp')),
      const Text(
        'Nhiều khuyến mãi hấp dẫn đang chờ đón bạn',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/payment.webp')),
      const Text(
        'Thực hiện thanh toán nhanh chóng',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/delivery1.webp')),
      const Text(
        'Giao hàng nhanh chóng đến trước cửa nhà bạn',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  )
];

class _OnBoardScreenState extends State<OnBoardScreen> {

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentPage++;

          if (_currentPage == 4)
            {_currentPage = 0;}
        });
      }
    });
    _controller.addListener(() {
      _currentPage = _controller.page as int;
    });
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: PageView(
            controller: _controller,
            children: [
              _pages[_currentPage]
            ],
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        const SizedBox(height: 20,),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            activeColor: mPrimaryColor,
          ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }
}
