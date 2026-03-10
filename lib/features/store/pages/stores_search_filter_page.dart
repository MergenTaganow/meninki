import 'package:flutter/material.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import 'package:meninki/features/global/blocs/key_filter_cubit/key_filter_cubit.dart';
import '../../../core/colors.dart';
import '../../../core/injector.dart';
import '../../province/blocks/province_selecting_cubit/province_selecting_cubit.dart';
import '../../province/widgets/province_selection.dart';

class StoresSearchFilterPage extends StatefulWidget {
  final void Function()? onFilter;
  const StoresSearchFilterPage({this.onFilter, super.key});

  @override
  State<StoresSearchFilterPage> createState() => _StoresSearchFilterPageState();
}

class _StoresSearchFilterPageState extends State<StoresSearchFilterPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(lg.filter, style: TextStyle(fontWeight: FontWeight.w500))),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 100,
            maxHeight: MediaQuery.of(context).size.height - 100,
          ),
          child: Padd(
            pad: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Box(h: 10),
                ProvinceSelection(
                  selectionKey: ProvinceSelectingCubit.storesSearchFilterProvince,
                  singleSelection: true,
                ),

                Spacer(),

                ///clear filter
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        clearStoresSearchFilters();
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(lg.clearFilter, style: TextStyle(color: Color(0xFF474747))),
                        ),
                      ),
                    ),
                    Box(h: 10),

                    ///save and go
                    InkWell(
                      onTap: () {
                        Go.pop();
                        if (widget.onFilter != null) {
                          widget.onFilter!();
                        }
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Col.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(child: Text(lg.save, style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

clearStoresSearchFilters() {
  sl<ProvinceSelectingCubit>().emptySelections(ProvinceSelectingCubit.storesSearchFilterProvince);
}
