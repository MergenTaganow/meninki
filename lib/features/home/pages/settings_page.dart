import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/data/dynamic_localization.dart';
import 'package:meninki/features/address/widgets/address_sheet.dart';
import 'package:meninki/features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'package:meninki/features/auth/data/employee_local_data_source.dart';
import 'package:meninki/features/home/model/profile.dart';
import 'package:meninki/features/home/widgets/language_sheet.dart';
import 'package:meninki/features/store/widgets/store_sheet.dart';

import '../../../core/injector.dart';
import '../../../my_app.dart';
import '../../address/bloc/get_address_cubit/get_address_cubit.dart';

class SettingsPage extends StatefulWidget {
  final Profile profile;
  const SettingsPage(this.profile, {super.key});

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
              singleLine(
                title: lg.selectLanguage,
                value: Text(DynamicLocalization.translate(lg.localeName)),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Color(0xFFF3F3F3),
                    builder: (context) {
                      return LanguageSheet();
                    },
                  );
                },
              ),

              singleLine(
                title: lg.downloads,
                value: Icon(Icons.download, size: 20),
                onTap: () {
                  Go.to(Routes.downloadsPage);
                },
              ),
              Box(h: 10),

              Text(lg.profile, style: TextStyle(color: Color(0xFF969696), fontSize: 12)),
              Box(h: 10),
              singleLine(
                title: lg.updateProfile,
                svgIcon: 'change_profile_image',
                onTap: () {
                  Go.to(Routes.profileUpdateScreen, argument: {'profile': widget.profile});
                },
              ),
              singleLine(
                title: lg.fillAddress,
                value: Icon(Icons.navigate_next),
                onTap: () {
                  context.read<GetAddressCubit>().getMyAddresses();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Color(0xFFF3F3F3),
                    builder: (context) {
                      return DraggableScrollableSheet(
                        expand: false,
                        maxChildSize: 0.85,
                        builder: (context, scrollController) {
                          return AddressSheet(scrollController);
                        },
                      );
                    },
                  );
                },
              ),
              // singleLine(title: lg.accountInfo, value: Icon(Icons.navigate_next)),
              // Box(h: 10),
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
              singleLine(
                title: lg.deleteAccount,
                value: Svvg.asset('delete', size: 25),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AreYouSureSheet(
                        title: lg.deleteAccount,
                        onYes: () {
                          context.read<AuthBloc>().add(DeleteUser());
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenu<String> languageChange(BuildContext context, AppLocalizations lg) {
    return DropdownMenu<String>(
      width: MediaQuery.of(context).size.width - 16,
      textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      menuStyle: MenuStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: const EdgeInsets.only(left: 14),
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
          padding: EdgeInsets.only(left: 14, right: 18),
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
