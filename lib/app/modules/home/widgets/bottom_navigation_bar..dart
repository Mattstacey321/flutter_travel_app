import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.image_outlined), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: ""),
      ],
    );
  }
}
