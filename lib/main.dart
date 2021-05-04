import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_travel_app/app/modules/home/views/home_view.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowGlow();
        return false;
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark().copyWith(
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: Colors.white, unselectedItemColor: Colors.grey)),
        theme: ThemeData.light(),
        themeMode: ThemeMode.dark,
        home: HomeView(),
      ),
    );
  }
}
