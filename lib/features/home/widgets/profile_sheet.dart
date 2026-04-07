import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meninki/features/home/model/profile.dart';

import '../../../core/helpers.dart';
import '../../appeal/bloc/appeal_cubit/appeal_cubit.dart';
import '../../appeal/widgets/appeal_sheet.dart';

class PublicProfileSheet extends StatelessWidget {
  final Profile profile;
  const PublicProfileSheet(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Padd(
      hor: 16,
      ver: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          singleLine(
            context: context,
            title: AppLocalizations.of(context)!.copyLink,
            value: Svvg.asset("url"),
            onTap: () {},
          ),
          singleLine(
            context: context,
            title: AppLocalizations.of(context)!.complaint,
            value: Svvg.asset("danger_light"),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return AppealSheet(
                    type: Appeal.profile,
                    typeId: profile.id.toString(),
                    typeName: profile.username,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget singleLine({
    required BuildContext context,
    required String title,
    required Widget value,
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
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
                value,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
