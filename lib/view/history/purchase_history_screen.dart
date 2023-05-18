import 'package:flutter/material.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/view/history/components/list_data.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  final int select;
  const PurchaseHistoryScreen({super.key, required this.select});

  @override
  _PurchaseHistoryScreenState createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen>
    with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(initialIndex: widget.select, length: 3, vsync: this);
    super.initState();
  }

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
                    controller: _tabController,
                    labelColor: mPrimaryColor,
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: const BoxDecoration(
                        /*gradient: const LinearGradient(
                            colors: [mHighColor, mPrimaryColor]),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.redAccent*/
                        border: Border(
                            bottom: BorderSide(color: mPrimaryColor, width: 3)
                        )
                    ),
                    tabs: const [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Đang xử lý",
                            style: TextStyle(fontSize: 15),),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Đã nhận hàng",
                            style: TextStyle(fontSize: 15),),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Đơn đã hủy",
                            style: TextStyle(fontSize: 15),),
                        ),
                      ),
                    ]),
              ),
              body: TabBarView(
                controller: _tabController,
                  children: const [
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