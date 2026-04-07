import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/colors.dart';
import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../../data/deep_link.dart';
import '../../appeal/bloc/appeal_cubit/appeal_cubit.dart';
import '../../appeal/widgets/appeal_sheet.dart';
import '../../global/blocs/delete_items_cubit/delete_items_cubit.dart';
import '../../global/widgets/custom_snack_bar.dart';
import '../../store/widgets/store_sheet.dart';
import '../models/product.dart';

class MyProductSheet extends StatelessWidget {
  final Product product;
  const MyProductSheet(this.product, {super.key});

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

class PublicProductSheet extends StatelessWidget {
  final Product product;
  const PublicProductSheet(this.product, {super.key});

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
            title: AppLocalizations.of(context)!.deeplink,
            value: Svvg.asset("url"),
            onTap: () async {
              var link = DeepLink().createDeepLink(id: product.id, type: DeepLink.product);
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
                    type: Appeal.product,
                    typeId: product.id.toString(),
                    typeName: product.name.trans(context),
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
