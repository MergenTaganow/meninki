import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../blocks/province_selecting_cubit/province_selecting_cubit.dart';
import '../models/province.dart';

class ProvinceSelection extends StatelessWidget {
  final String selectionKey;
  final bool singleSelection;
  const ProvinceSelection({super.key, required this.selectionKey, required this.singleSelection});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProvinceSelectingCubit, ProvinceSelectingState>(
      builder: (context, state) {
        if (state is ProvinceSelectingSuccess) {
          List<Province> selecteds = state.selectedMap[selectionKey] ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Велаят"),
              Box(h: 6),
              GestureDetector(
                onTap: () {
                  Go.to(
                    Routes.provinceSelectingPage,
                    argument: {'selectionKey': selectionKey, "singleSelection": singleSelection},
                  );
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Color(0xFF474747)),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selecteds.isEmpty
                              ? 'Выбери Велаят'
                              : selecteds.map((e) => e.name.tk).join(', '),
                          style: TextStyle(color: Color(0xFF969696)),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right_outlined, size: 18),
                      Box(w: 5),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
