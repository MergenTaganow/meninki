import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final List<Color> colors = [
    Colors.white,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.lightBlue,
    Colors.blue,
    Colors.purple,
    Colors.deepPurple,
    Colors.pink,
    Colors.brown,
  ];

  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  ColorPicker({required this.selectedColor, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          colors.map((color) {
            final isSelected = color == selectedColor;
            return InkWell(
              onTap: () => onColorSelected(color),
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
            );
          }).toList(),
    );
  }
}
