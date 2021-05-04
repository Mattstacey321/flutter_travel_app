import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoItem extends StatefulWidget {
  final String imagePath;
  PhotoItem({required this.imagePath});
  @override
  _PhotoItemState createState() => _PhotoItemState();
}

class _PhotoItemState extends State<PhotoItem> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: 200.milliseconds);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
        });
      });
          controller.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      // And slide transition
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(-1, 0),
          end: Offset.zero,
        ).animate(animation),
        // Paste you Widget
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.cover,
            height: 100,
            width: 100,
          ),
        ),
      ),
    );
  }
}
