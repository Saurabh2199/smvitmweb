import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smvitm_web/config/color_palette.dart';
import 'package:smvitm_web/providers/categories.dart';
import 'package:smvitm_web/providers/faculties.dart';
import 'package:smvitm_web/screens/add_feed_screen.dart';
import 'package:smvitm_web/screens/login_screen.dart';
import 'package:smvitm_web/screens/select_category_screen.dart';
import 'package:smvitm_web/screens/splash_screen.dart';
import 'package:smvitm_web/widgets/loading.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMVITM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ColorPalette.primaryColor,
        accentColor: ColorPalette.accentColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        SplashScreen.routeName: (context) => SplashScreen(),
        AddFeedScreen.routeName: (context) => AddFeedScreen(),
        SelectCategoryScreen.routeName: (context) => SelectCategoryScreen(),
      },
    );
  }
}
