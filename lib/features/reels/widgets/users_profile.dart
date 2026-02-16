import 'package:flutter/material.dart';

import '../../auth/models/user.dart';

class UsersProfile extends StatelessWidget {
  final User user;
  const UsersProfile(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
          // child: MeninkiNetworkImage(file: user., networkImageType: networkImageType),
        ),
        Positioned(bottom: -10, child: Icon(Icons.add_circle, color: Color(0xFFC7281F))),
      ],
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int trimLines;

  const ExpandableText({super.key, required this.text, this.style, this.trimLines = 2});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  void _toggleExpanded() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleExpanded,
      child: Text(
        widget.text,
        style: widget.style ?? TextStyle(color: Colors.white, fontSize: 16),
        maxLines: _expanded ? null : widget.trimLines,
        overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
    );
  }
}
