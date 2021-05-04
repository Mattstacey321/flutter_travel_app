import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircleButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onTap;
  final Color? bgColor;
  final String tooltip;
  final bool showToolTip;
  CircleButton({
    required this.onTap,
    required this.icon,
    this.bgColor,
    this.showToolTip = false,
    required this.tooltip,
  });
  @override
  Widget build(BuildContext context) {
    final double iconSize = 20;
    return Material(
      color: Colors.transparent,
      child: _buildTooltip(
        context,
        showToolTip,
        InkWell(
          splashColor: Colors.grey.withOpacity(0.2),
          customBorder: CircleBorder(),
          onTap: onTap,
          child: Container(
     
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              //borderRadius: BorderRadius.circular(1000),
              color: bgColor,
            ),
            child: IconTheme(
              data: IconThemeData(
                size: iconSize ,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTooltip(BuildContext context, bool showTooltip, Widget child) {
    return context.isPhone
        ? Tooltip(message: tooltip, child: child)
        : showToolTip
            ? Tooltip(message: tooltip, child: child)
            : child;
  }
}
