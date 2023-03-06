import 'package:flutter/material.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/view/history/components/list_data.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  @override
  _PurchaseHistoryScreenState createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: DefaultTabController(
            length: 3,
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
                  'Đơn hàng của tôi',
                  style: TextStyle(
                    fontSize: mFontTitle,
                    color: mPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                bottom: TabBar(
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [mHighColor, mPrimaryColor]),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.redAccent),
                    tabs: const [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Đang xử lý"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Đã nhận hàng"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Đơn đã hủy"),
                        ),
                      ),
                    ]),
              ),
              body: TabBarView(children: [
                ListData(status: "Đang xử lý"),
                ListData(status: "Đã nhận hàng"),
                ListData(status: "Đơn đã hủy"),
              ]),
            )
        ),
      ),
    );
  }
}