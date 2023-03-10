import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/components/ThemeManager.dart';
import 'package:store_app/view/account_screen/account_screen.dart';
import 'package:store_app/view/home/dashboard_screen.dart';
import 'package:store_app/view/login/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'view/card/card_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  SharedPreferences? prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  MyApp({Key? key,  this.prefs}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => MaterialApp(
        title: 'Flutter Login',
        debugShowCheckedModeBanner: false,
        theme: theme.lightTheme,
        home: SplashScreen(),
        routes: {
          '/home': (context) => HomeScreen(id: ""),
          '/account': (context) => AccountScreen(),
          '/card': (context) => CardScreen(id: ""),
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}
