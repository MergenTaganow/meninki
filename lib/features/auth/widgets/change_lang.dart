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
      child: Svvg.asset('language'),
      onSelected: (item) {
        MyApp.setLocale(context, Locale(item));
      },
      itemBuilder:
          (BuildContext? contextt) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'tk', child: Text("Turkmen")),
            const PopupMenuItem<String>(value: 'ru', child: Text("Russian")),
            const PopupMenuItem<String>(value: 'en', child: Text("English")),
          ],
    );
  }

  // getLocale(AppLocalizations lg) {
  //   return lg.localeName == 'tr' ? 'TM' : lg.localeName.toUpperCase();
  // }
}
