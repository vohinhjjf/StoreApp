import 'package:flutter/material.dart';
import 'package:store_app/constant.dart';

import '../review/components/list_not_review.dart';
import 'components/list_reviewed.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: mPrimaryColor,
                      size: mFontListTile,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                backgroundColor: Colors.white,
                centerTitle: true,
                title: const Text(
                  'Đánh giá của tôi',
                  style: TextStyle(
                    fontSize: mFontTitle,
                    color: mPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                bottom: const TabBar(
                    labelColor: mPrimaryColor,
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        // gradient: const LinearGradient(
                        //     colors: [mHighColor, mPrimaryColor]),
                        //borderRadius: BorderRadius.circular(50),
                        //color: Colors.redAccent,
                        border: Border(
                          bottom: BorderSide(color: mPrimaryColor, width: 3)
                        )
                    ),
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Chưa đánh giá",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Đã đánh giá",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ]),
              ),
              body: const TabBarView(
                  children: [
                    ListNotReview(),
                    ListReviewed(),
              ]),
            )
        ),
      ),
    );
  }
}