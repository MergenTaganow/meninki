import 'package:flutter/material.dart';

class ImagesBackButton extends StatelessWidget {
  final Color iconColor;
  final VoidCallback? onTap;

  const ImagesBackButton({super.key, this.onTap, this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      top: 16,
      child: SafeArea(
        child: GestureDetector(
          onTap: onTap ?? () => Navigator.of(context).pop(),
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.28), // subtle background
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center, // center child exactly
            child: Icon(
              Icons.navigate_before, // simpler icon, better centered
              color: iconColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
