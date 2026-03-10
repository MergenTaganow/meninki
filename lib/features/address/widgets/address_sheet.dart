import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/address/bloc/address_create_cubit/address_create_cubit.dart';
import 'package:meninki/features/address/bloc/get_address_cubit/get_address_cubit.dart';
import '../../../core/helpers.dart';
import '../../basket/bloc/prepare_basket_cubit/prepare_basket_cubit.dart';

class AddressSheet extends StatelessWidget {
  final ScrollController scrollController;
  final bool selectable;

  const AddressSheet(this.scrollController, {this.selectable = false, super.key});

  @override
  Widget build(BuildContext context) {
    final lg = AppLocalizations.of(context)!;

    return BlocListener<AddressCreateCubit, AddressCreateState>(
      listener: (context, state) {
        if (state is AddressEditSuccess) {
          context.read<GetAddressCubit>().getMyAddresses();
        }
      },
      child: Padd(
        hor: 16,
        ver: 30,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 18),
                Text(lg.myAddresses),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Go.to(Routes.address_create_page);
                  },
                  child: Icon(Icons.add_circle),
                ),
              ],
            ),
            Box(h: 20),

            Expanded(
              child: BlocBuilder<GetAddressCubit, GetAddressState>(
                builder: (context, state) {
                  print(state);
                  if (state is GetAddressLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is GetAddressSuccess) {
                    return ListView.builder(
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        return singleLine(
                          context: context,
                          title:
                              state.addresses[index].info ??
                              state.addresses[index].region?.name?.trans(context) ??
                              '',
                          id: state.addresses[index].id ?? 0,
                          onTap: () {
                            if (selectable) {
                              print(state.addresses[index].id);
                              context.read<PrepareBasketCubit>().prepareBasket(
                                state.addresses[index].id ?? 0,
                              );
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                      itemCount: state.addresses.length,
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget singleLine({
    required BuildContext context,
    required String title,
    required int id,
    void Function()? onTap,
  }) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Padd(
      bot: 10,
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          extentRatio: 0.4,
          children: [
            const Box(w: 2),
            CustomSlidableAction(
              borderRadius: BorderRadius.circular(14),
              backgroundColor: Colors.red.withOpacity(0.5),
              onPressed: (_) {
                context.read<AddressCreateCubit>().deleteAddress(id);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Svvg.asset("delete"),
                  Text(
                    lg.deleteAddress,
                    style: const TextStyle(fontSize: 12, color: Color(0xFFC7281F)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        child: Material(
          color: Colors.white, // 👈 MOVE background HERE
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.black.withOpacity(0.15),
            highlightColor: Colors.black.withOpacity(0.05),
            onTap: onTap,
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
      ),
    );
  }
}
