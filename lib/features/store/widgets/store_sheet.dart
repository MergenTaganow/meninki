import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/store/models/market.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/helpers.dart';
import '../../../data/deep_link.dart';
import '../../appeal/bloc/appeal_cubit/appeal_cubit.dart';
import '../../appeal/widgets/appeal_sheet.dart';
import '../../global/widgets/custom_snack_bar.dart';

class MyMarketSheet extends StatelessWidget {
  final Market market;
  const MyMarketSheet(this.market, {super.key});

  @override
  Widget build(BuildContext context) {
    final lg = AppLocalizations.of(context)!;

    return Padd(
      hor: 16,
      ver: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          singleLine(
            context: context,
            title: lg.editStore,
            value: Svvg.asset("profile"),
            onTap: () {
              Go.to(Routes.storeCreatePage, argument: {"market": market});
            },
          ),
          singleLine(
            context: context,
            title: lg.colorPattern,
            value: Svvg.asset("schemePicker"),
            onTap: () {
              Go.to(Routes.colorSchemeSelectingPage, argument: {'market': market});
            },
          ),
          singleLine(
            context: context,
            title: lg.marketAdds,
            value: Svvg.asset("schemePicker"),
            onTap: () {
              Go.to(Routes.marketBannersPage, argument: {'market': market});
            },
          ),
          singleLine(
            context: context,
            title: lg.marketOrders,
            value: Svvg.asset("schemePicker"),
            onTap: () {
              Go.to(Routes.marketOrdersPage, argument: {'marketId': market.id});
            },
          ),
          singleLine(
            context: context,
            title: AppLocalizations.of(context)!.copyLink,
            value: Svvg.asset("url"),
            onTap: () {},
          ),
          singleLine(
            context: context,
            title: lg.deleteStore,
            value: Svvg.asset("delete"),
            textColor: Col.redTask,
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
            padding: const EdgeInsets.all(14),
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

class PublicMarketSheet extends StatelessWidget {
  final Market market;
  const PublicMarketSheet(this.market, {super.key});

  @override
  Widget build(BuildContext context) {
    final lg = AppLocalizations.of(context)!;

    return Padd(
      hor: 16,
      ver: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          singleLine(
            context: context,
            title: AppLocalizations.of(context)!.deeplink,
            value: Svvg.asset("url"),
            onTap: () async {
              var link = DeepLink().createDeepLink(id: market.id, type: DeepLink.market);
              SharePlus.instance.share(ShareParams(text: '${lg.checkThis} $link'));
            },
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
                    type: Appeal.market,
                    typeId: market.id.toString(),
                    typeName: market.name,
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
            padding: const EdgeInsets.all(14),
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

class AreYouSureSheet extends StatelessWidget {
  final String title;
  final void Function()? onYes;
  const AreYouSureSheet({super.key, required this.title, this.onYes});

  @override
  Widget build(BuildContext context) {
    final lg = AppLocalizations.of(context)!;
    return Padd(
      hor: 16,
      ver: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
          Box(h: 10),
          Text(lg.areYouSure),
          Box(h: 20),
          singleLine(
            context: context,
            title: AppLocalizations.of(context)!.yes,
            value: Container(),
            onTap: onYes,
          ),
          singleLine(
            context: context,
            title: AppLocalizations.of(context)!.no,
            value: Container(),
            onTap: () {
              Navigator.pop(context);
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
            padding: const EdgeInsets.all(14),
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
