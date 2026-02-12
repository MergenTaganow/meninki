import 'package:flutter/material.dart';

class SmartEllipsisText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const SmartEllipsisText({
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (!textPainter.didExceedMaxLines) {
          return Text(text, style: style);
        }

        // Split filename and extension
        final lastDot = text.lastIndexOf('.');
        if (lastDot == -1 || lastDot == text.length - 1) {
          // No extension found, use regular ellipsis
          return Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          );
        }

        final name = text.substring(0, lastDot);
        final extension = text.substring(lastDot); // includes the dot

        // Calculate how much space we have
        final ellipsis = '...';
        final extensionPainter = TextPainter(
          text: TextSpan(text: extension, style: style),
          textDirection: TextDirection.ltr,
        )..layout();

        final ellipsisPainter = TextPainter(
          text: TextSpan(text: ellipsis, style: style),
          textDirection: TextDirection.ltr,
        )..layout();

        final availableWidth = constraints.maxWidth -
            extensionPainter.width -
            ellipsisPainter.width;

        // Find how much of the name we can show
        String truncatedName = name;
        final namePainter = TextPainter(
          text: TextSpan(text: name, style: style),
          textDirection: TextDirection.ltr,
        )..layout();

        if (namePainter.width > availableWidth) {
          // Binary search for the right length
          int left = 0;
          int right = name.length;

          while (left < right) {
            final mid = (left + right + 1) ~/ 2;
            final testName = name.substring(0, mid);
            final testPainter = TextPainter(
              text: TextSpan(text: testName, style: style),
              textDirection: TextDirection.ltr,
            )..layout();

            if (testPainter.width <= availableWidth) {
              left = mid;
            } else {
              right = mid - 1;
            }
          }

          truncatedName = name.substring(0, left);
        }

        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: truncatedName),
              TextSpan(text: ellipsis),
              TextSpan(text: extension),
            ],
            style: style,
          ),
          maxLines: 1,
        );
      },
    );
  }
}