import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helpers.dart';
import '../../../my_app.dart';
import '../../auth/bloc/aut_bloc/auth_bloc.dart';

class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padd(
      hor: 16,
      ver: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          singleLine(context: context, title: AppLocalizations.of(context)!.tr, value: 'tk'),
          singleLine(context: context, title: AppLocalizations.of(context)!.ru, value: 'ru'),
          singleLine(context: context, title: AppLocalizations.of(context)!.en, value: 'en'),
        ],
      ),
    );
  }

  Widget singleLine({
    required BuildContext context,
    required String title,
    required String value,
    void Function()? onTap,
  }) {
    AppLocalizations lg = AppLocalizations.of(context)!;
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
            MyApp.setLocale(context, Locale(value));
            if (value != lg.localeName) {
              if (value == 'tr') value = 'tk';
              context.read<AuthBloc>().add(SetLanguage(value));
            }
          },
          child: Container(
            height: 46,
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text(title, style: TextStyle(fontWeight: FontWeight.w500))],
            ),
          ),
        ),
      ),
    );
  }
}
