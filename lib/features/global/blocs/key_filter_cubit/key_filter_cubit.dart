import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'key_filter_state.dart';

class KeyFilterCubit extends Cubit<KeyFilterState> {
  KeyFilterCubit() : super(KeyFilterSuccess(const {}));
  Map<String, String?> selectedMap = {};

  select({required String key, required String? value}) {
    selectedMap[key] = value;
    emit.call(KeyFilterSuccess(selectedMap));
  }

  static String product_search_min_price = "product_search_min_price";
  static String product_search_max_price = "product_search_max_price";

  // static showRadioSelectionSheet(
  //     {required BuildContext context,
  //     required String cubitsKey,
  //     required Map<String?, String> values}) {
  //   return showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       AppLocalizations lg = AppLocalizations.of(context)!;
  //
  //       return StatefulBuilder(builder: (context, setState1) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Padd(
  //               top: 30,
  //               bot: 15,
  //               child: Text(
  //                 lg.sort,
  //                 style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
  //               ),
  //             ),
  //             BlocBuilder<KeyFilterCubit, KeyFilterState>(
  //               builder: (context, state) {
  //                 if (state is KeyFilterSuccess) {
  //                   var filter = state.selectedMap[cubitsKey];
  //                   return Padd(
  //                     hor: 16,
  //                     child: ListView.builder(
  //                       itemCount: values.length,
  //                       shrinkWrap: true,
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       itemBuilder: (context, index) {
  //                         String? key = values.keys.toList()[index]; // Get the key of each map
  //                         String label = values.values.toList()[index];
  //                         return RadioListTile<String?>(
  //                           title: Text(label),
  //                           value: key,
  //                           groupValue: filter,
  //                           onChanged: (value) {
  //                             context.read<KeyFilterCubit>().select(key: cubitsKey, value: key);
  //                           },
  //                         );
  //                       },
  //                     ),
  //                   );
  //                 }
  //                 return Container();
  //               },
  //             ),
  //             Box(h: 30),
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Container(
  //                 height: 40,
  //                 width: 120,
  //                 decoration: BoxDecoration(
  //                   color: Col.primary,
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Padd(
  //                   child: const Center(
  //                     child: Text(
  //                       "OK",
  //                       style: TextStyle(
  //                           color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Box(h: 30),
  //           ],
  //         );
  //       });
  //     },
  //   );
  // }
}
