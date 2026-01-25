import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'package:meninki/features/auth/bloc/register_cubit/register_cubit.dart';
import 'package:meninki/features/store/widgets/store_sheet.dart';

import '../../../my_app.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: Color(0xFF969696).withOpacity(0.3), width: 0.3),
  );
  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      appBar: AppBar(title: Text(lg.settings)),
      body: Padd(
        hor: 8,
        ver: 10,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lg.general, style: TextStyle(color: Color(0xFF969696), fontSize: 12)),
              Box(h: 10),
              languageChange(context, lg),
              Box(h: 10),

              Text(lg.profile, style: TextStyle(color: Color(0xFF969696), fontSize: 12)),
              Box(h: 10),
              singleLine(title: lg.changePhoto, svgIcon: 'change_profile_image'),
              singleLine(title: lg.accountInfo, value: Icon(Icons.navigate_next)),
              Box(h: 10),
              Text(lg.account, style: TextStyle(color: Color(0xFF969696), fontSize: 12)),
              Box(h: 10),
              singleLine(
                title: lg.logout,
                svgIcon: 'logout',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AreYouSureSheet(
                        title: lg.logout,
                        onYes: () {
                          context.read<AuthBloc>().add(LogoutEvent());
                        },
                      );
                    },
                  );
                },
              ),
              singleLine(title: lg.deleteAccount, value: Svvg.asset('delete', size: 25)),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenu<String> languageChange(BuildContext context, AppLocalizations lg) {
    return DropdownMenu<String>(
      width: MediaQuery.of(context).size.width - 20,
      menuStyle: MenuStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: const EdgeInsets.only(left: 10),
        constraints: BoxConstraints.tight(const Size.fromHeight(46)),
        fillColor: Colors.white,
        filled: true,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintStyle: TextStyle(color: Color(0xFF969696)),
      ),

      hintText: lg.selectLanguage,
      // dropdownColor: Colors.white,
      trailingIcon: Icon(Icons.keyboard_arrow_down_outlined),
      selectedTrailingIcon: Icon(Icons.keyboard_arrow_up_outlined),
      initialSelection: lg.localeName,
      onSelected: (value) {
        if (value != null) {
          MyApp.setLocale(context, Locale(value));
          if (value != lg.localeName) {
            if (value == 'tr') value = 'tk';
            context.read<AuthBloc>().add(SetLanguage(value));
          }
        }
      },
      dropdownMenuEntries: [
        DropdownMenuEntry<String>(value: 'tr', label: "turkmen"),
        DropdownMenuEntry<String>(value: 'ru', label: "russian"),
        DropdownMenuEntry<String>(value: 'en', label: "English"),
      ],
    );
  }

  Widget singleLine({
    required String title,
    String? svgIcon,
    Widget? value,
    void Function()? onTap,
  }) {
    return Padd(
      bot: 10,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        splashColor: Colors.black.withOpacity(0.08),
        highlightColor: Colors.black.withOpacity(0.04),
        child: Container(
          height: 44,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Color(0xFF969696).withOpacity(0.3), width: 0.3),
          ),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w500))),
                value ?? Svvg.asset(svgIcon ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
