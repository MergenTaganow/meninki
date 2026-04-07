import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/data/dynamic_localization.dart';

import '../../../core/helpers.dart';
import '../bloc/appeal_cubit/appeal_cubit.dart';

class AppealSheet extends StatelessWidget {
  final String type;
  final String typeId;
  final String? typeName;

  const AppealSheet({required this.type, required this.typeId, required this.typeName, super.key});

  @override
  Widget build(BuildContext context) {
    final lg = AppLocalizations.of(context)!;

    return Padd(
      hor: 16,
      ver: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nama boýunça arz etmek isleýaniz", style: TextStyle(fontWeight: FontWeight.w500)),
          Box(h: 20),
          ...Appeal.topics
              .map(
                (e) => singleLine(
                  context: context,
                  title: DynamicLocalization.translate(e),
                  onTap: () {
                    Go.to(
                      Routes.appealPage,
                      argument: {"type": type, "topic": e, "typeId": typeId, "typeName": typeName},
                    );
                  },
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget singleLine({
    required BuildContext context,
    required String title,
    void Function()? onTap,
    Color? textColor,
  }) {
    return Padd(
      bot: 10,
      child: Material(
        color: Colors.white, // 👈 MOVE background HERE
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          splashColor: Colors.black.withOpacity(0.15),
          highlightColor: Colors.black.withOpacity(0.05),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context);
            if (onTap != null) {
              onTap();
            }
          },
          child: Container(
            height: 46,
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
