import 'package:flutter/material.dart';
import 'package:meninki/features/store/widgets/store_background_color_selection.dart';

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  ColorPicker({super.key, required this.selectedColor, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          MarketColorScheme.backgroundColors.map((color) {
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
