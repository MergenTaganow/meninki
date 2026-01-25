import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              Text(AppLocalizations.of(context)!.province),
              const SizedBox(height: 6),

              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  splashColor: Colors.black.withOpacity(0.08),
                  highlightColor: Colors.black.withOpacity(0.04),
                  onTap: () {
                    HapticFeedback.selectionClick();

                    Future.delayed(const Duration(milliseconds: 120), () {
                      Go.to(
                        Routes.provinceSelectingPage,
                        argument: {
                          'selectionKey': selectionKey,
                          'singleSelection': singleSelection,
                        },
                      );
                    });
                  },
                  child: Ink(
                    height: 50,
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF474747)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selecteds.isEmpty
                                ? AppLocalizations.of(context)!.selectProvince
                                : selecteds.map((e) => e.name.tk).join(', '),
                            style: const TextStyle(color: Color(0xFF969696)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right_outlined, size: 18),
                        const SizedBox(width: 5),
                      ],
                    ),
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
