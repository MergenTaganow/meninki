import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/helpers.dart';

class BottomNavBar extends StatefulWidget {
  final TabController controller;
  const BottomNavBar(this.controller, {super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Color(0xFFEAEAEA), width: 2),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(4, (index) {
          var icons = ['home', 'search', 'add_card', 'profile'];
          return InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              widget.controller.animateTo(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.controller.index == index
                    ? Colors.black
                    : const Color(0xFFF3F3F3),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Svvg.asset(
                    icons[index],
                    key: ValueKey(widget.controller.index == index),
                    color: widget.controller.index == index
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            )
          );
        }),
      ),
    );
  }
}
