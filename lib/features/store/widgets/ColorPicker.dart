import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final List<Color> colors = [
    Color(0xFFffffff),
    Color(0xFFFAF5F2),
    Color(0xFFF4EFEB),
    Color(0xFFF0ECE1),
    Color(0xFFE7E2D6),
    Color(0xFFAFA8B4),
    Color(0xFF757377),
    Color(0xFF3B353F),
    Color(0xFFB71764),
    Color(0xFFFB0D7F),
    Color(0xFF7A4267),
    Color(0xFF000000),
  ];

  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  ColorPicker({super.key, required this.selectedColor, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          colors.map((color) {
            final isSelected = color == selectedColor;
            return Material(
              color: Colors.transparent, // make material transparent to show the color
              shape: CircleBorder(),
              child: InkWell(
                customBorder: CircleBorder(), // ensures ripple stays circular
                onTap: () => onColorSelected(color),
                splashColor: Colors.white.withOpacity(0.3), // adjust for nice effect
                highlightColor: Colors.white.withOpacity(0.1),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border:
                        color == Colors.white
                            ? Border.all(color: Colors.black)
                            : isSelected
                            ? Border.all(
                              color: color == Colors.white ? Colors.black : Colors.white,
                              width: 1,
                            )
                            : null,
                  ),
                  child:
                      isSelected
                          ? Icon(
                            Icons.check,
                            color: color == Colors.white ? Colors.black : Colors.white,
                          )
                          : null,
                ),
              ),
            );
          }).toList(),
    );
  }
}
