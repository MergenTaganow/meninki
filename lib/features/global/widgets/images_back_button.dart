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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.28), // subtle background
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios, // iOS‑style chevron
              color: iconColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
