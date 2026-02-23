import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/global/blocs/delete_items_cubit/delete_items_cubit.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meninki/features/store/models/market.dart';
import '../../../core/helpers.dart';

class MarketSheet extends StatelessWidget {
  final Market market;
  const MarketSheet(this.market, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padd(
      hor: 16,
      ver: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          singleLine(
            context: context,
            title: "Редактировать профиль",
            value: Svvg.asset("profile"),
            onTap: () {
              Go.to(Routes.storeCreatePage, argument: {"market": market});
            },
          ),
          singleLine(
            context: context,
            title: "Цветовая схема",
            value: Svvg.asset("schemePicker"),
            onTap: () {
              Go.to(Routes.colorSchemeSelectingPage, argument: {'market': market});
            },
          ),
          singleLine(
            context: context,
            title: "Обявлния магазина",
            value: Svvg.asset("schemePicker"),
            onTap: () {
              Go.to(Routes.marketBannersPage, argument: {'market': market});
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
            title: "Удалить магазин",
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

class ProductSheet extends StatelessWidget {
  final Product product;
  const ProductSheet(this.product, {super.key});

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
            title: lg.editProduct,
            value: Svvg.asset("profile"),
            onTap: () {
              Go.to(
                Routes.productCreate,
                argument: {"storeId": product.market?.id, "product": product},
              );
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
            title: lg.deleteProduct,
            value: Svvg.asset("delete", size: 24),
            textColor: Col.redTask,
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return AreYouSureSheet(
                    title: lg.deleteProduct,
                    onYes: () {
                      context.read<DeleteItemsCubit>().deleteProduct(product.id);
                    },
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

class AreYouSureSheet extends StatelessWidget {
  final String title;
  final void Function()? onYes;
  const AreYouSureSheet({super.key, required this.title, this.onYes});

  @override
  Widget build(BuildContext context) {
    return Padd(
      hor: 16,
      ver: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
          Box(h: 10),
          Text("Вы уверены в своем решении?"),
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
