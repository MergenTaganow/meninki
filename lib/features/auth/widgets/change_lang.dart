import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../../../core/helpers.dart';
import '../../../my_app.dart';

class EditLang extends StatelessWidget {
  final bool col;
  const EditLang({super.key, this.col = true});

  @override
  Widget build(BuildContext context) {
    // AppLocalizations lg = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      elevation: 1.5,
      color: Col.white,
      offset: const Offset(0, 30),
      child: Padd(ver: 10, hor: 16, child: Row(children: [const Icon(Icons.language)])),
      onSelected: (item) {
        MyApp.setLocale(context, Locale(item));
      },
      itemBuilder:
          (BuildContext? contextt) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'tr', child: Text("turkmen")),
            const PopupMenuItem<String>(value: 'ru', child: Text("russian")),
          ],
    );
  }

  // getLocale(AppLocalizations lg) {
  //   return lg.localeName == 'tr' ? 'TM' : lg.localeName.toUpperCase();
  // }
}
