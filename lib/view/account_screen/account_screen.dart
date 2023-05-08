import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/components/ThemeManager.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/view/account_info/account_info_screen.dart';
import 'package:store_app/view/blog/blog_screen.dart';
import 'package:store_app/view/history/purchase_history_screen.dart';
import 'package:store_app/view/login/splash_screen.dart';
import 'package:store_app/view/login/welcome_screen.dart';
import 'package:store_app/view/order/delivery_address.dart';
import 'package:store_app/view/review/review_screen.dart';
import 'package:store_app/view/stores/stores_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../payment/payment_home.dart';
import '../support_request/support_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User? user = FirebaseAuth.instance.currentUser;
  final auth = AuthProvider();
  bool check = false;
  String mode = "Light";

  @override
  void initState() {
    auth.checkPrefsID().then((value) => check = value);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => SafeArea(
            //theme: theme.getTheme(),
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 100.0,
                      floating: false,
                      pinned: true,
                      backgroundColor: Colors.grey[50],
                      flexibleSpace: const FlexibleSpaceBar(
                        centerTitle: false,
                        titlePadding: EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          'Thiết lập tài khoản',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ];
                },
                body: SingleChildScrollView(
                  //padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            const Text("Tài khoản",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 20)),
                            const SizedBox(height: 8),
                            Container(
                              height: 1,
                              color: Colors.grey.shade200,
                            ),
                            const SizedBox(height: 12),
                            Container(
                                height: 80,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.shade200),
                                child: InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    if (prefs.getString('ID') == '' ||
                                        prefs.getString('ID') == null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return WelcomeScreen();
                                          },
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return AccountInfoScreen();
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.shade300),
                                        child: Center(
                                          child: Icon(Icons.person,
                                              size: 32,
                                              color: Colors.grey.shade500),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      FutureBuilder(
                                          future: auth.checkPrefsID(),
                                          builder: (context,
                                              AsyncSnapshot<bool> snapshot) {
                                            if (snapshot.hasData) {
                                              return snapshot.data!
                                                  ? const Text(
                                                      "Thông tin tài khoản",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.blue,
                                                          fontSize: 16))
                                                  : const Text(
                                                      "Đăng nhập / Đăng kí",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.blue,
                                                          fontSize: 16));
                                            } else {
                                              return const CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.blue));
                                            }
                                          }),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 8),
                            _buildListTile(
                                'Địa chỉ giao hàng',
                                Icons.location_on_rounded,
                                '',
                                Colors.orange,
                                theme, onTab: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  const DeliveryAddressPage(),
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            _buildListTile('Thẻ tín dụng', Icons.credit_card, '',
                                Colors.lightGreen, theme, onTab: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                      PaymentHome(),
                                    ),
                                  );
                                }),
                            const SizedBox(height: 8),
                            _buildListTile(
                                'Đơn hàng của tôi',
                                Icons.playlist_add_check_circle_sharp,
                                '',
                                Colors.blue,
                                theme, onTab: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const PurchaseHistoryScreen(
                                        select: 0);
                                  },
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildBuyItems("Chờ xác nhận",
                                    Icons.account_balance_wallet_outlined,
                                    onTab: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const PurchaseHistoryScreen(
                                            select: 0);
                                      },
                                    ),
                                  );
                                }),
                                _buildBuyItems(
                                    "Chờ lấy hàng", CupertinoIcons.cube_box,
                                    onTab: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const PurchaseHistoryScreen(
                                            select: 1);
                                      },
                                    ),
                                  );
                                }),
                                _buildBuyItems(
                                    "Đã giao", Icons.fire_truck_outlined,
                                    onTab: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const PurchaseHistoryScreen(
                                            select: 2);
                                      },
                                    ),
                                  );
                                }),
                                _buildBuyItems("Đánh giá", Icons.stars_outlined,
                                    onTab: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const ReviewScreen();
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      Container(
                        height: 8,
                        color: Colors.grey.shade200,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            const Text("Cài đặt",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 20)),
                            const SizedBox(height: 8),
                            Container(
                              height: 1,
                              color: Colors.grey.shade200,
                            ),
                            const SizedBox(height: 12),
                            _buildListTile('Chế độ', Icons.dark_mode, mode,
                                Colors.purple, theme, onTab: () {
                              if (theme.getTheme() == theme.lightTheme) {
                                theme.setDarkMode();
                                setState(() {
                                  mode = "Night";
                                });
                              } else {
                                theme.setLightMode();
                                setState(() {
                                  mode = "Light";
                                });
                              }
                            }),
                            const SizedBox(height: 8),
                            _buildListTile('Chi nhánh cửa hàng', Icons.store,
                                '', Colors.blueGrey, theme, onTab: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return GetMyStores();
                                  },
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            _buildListTile(
                                'Góp ý', Icons.help, '', Colors.green, theme,
                                onTab: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SupportRequestScreen();
                                  },
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            _buildListTile('Đăng xuất', Icons.exit_to_app, '',
                                Colors.red, theme, onTab: () {
                              auth.deletePrefsID().then((value) => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return SplashScreen();
                                        },
                                      ),
                                    )
                                  });
                            }),
                          ],
                        ),
                      ),
                      Text("Version 1.0.0",
                          style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                ))));
  }

  Widget _buildListTile(
      String title, IconData icon, String trailing, Color color, theme,
      {onTab}) {
    return ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Container(
          width: 46,
          height: 46,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: color.withAlpha(30)),
          child: Center(
            child: Icon(
              icon,
              color: color,
            ),
          ),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: Container(
          width: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(trailing, style: const TextStyle()),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ],
          ),
        ),
        onTap: onTab);
  }

  Widget _buildBuyItems(String title, IconData icons, {onTab}) {
    return InkWell(
      onTap: onTab,
      child: Column(
        children: [
          Icon(
            icons,
            color: Colors.black,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
