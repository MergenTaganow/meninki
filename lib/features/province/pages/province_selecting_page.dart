import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';

import '../blocks/get_provinces_bloc/get_provinces_cubit.dart';
import '../blocks/province_selecting_cubit/province_selecting_cubit.dart';
import '../models/province.dart';

class ProvinceSelectingPage extends StatefulWidget {
  final String selectionKey;
  final bool singleSelection;

  const ProvinceSelectingPage({
    super.key,
    this.singleSelection = false,
    required this.selectionKey,
  });

  @override
  State<ProvinceSelectingPage> createState() => _ProvinceSelectingPageState();
}

class _ProvinceSelectingPageState extends State<ProvinceSelectingPage> {
  @override
  void initState() {
    super.initState();
    // Fetch provinces when page opens
    context.read<GetProvincesCubit>().getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Велаят", style: TextStyle(fontWeight: FontWeight.w500))),
      body: Padd(
        pad: 10,
        child: BlocBuilder<GetProvincesCubit, GetProvincesState>(
          builder: (context, state) {
            if (state is GetProvincesLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is GetProvincesFailed) {
              return Center(child: Text(state.failure.message ?? "Ошибка"));
            }
            if (state is GetProvincesSuccess) {
              final provinces = state.provinces;

              return BlocBuilder<ProvinceSelectingCubit, ProvinceSelectingState>(
                builder: (context, selectState) {
                  List<Province>? selecteds;
                  if (selectState is ProvinceSelectingSuccess) {
                    selecteds = selectState.selectedMap[widget.selectionKey] ?? [];
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: provinces.length + (widget.singleSelection ? 0 : 1),
                          separatorBuilder: (_, __) => const SizedBox(height: 6),
                          itemBuilder: (context, index) {
                            final isAllItem = !widget.singleSelection && index == 0;

                            if (isAllItem) {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.black.withOpacity(0.06),
                                  highlightColor: Colors.black.withOpacity(0.03),
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    context.read<ProvinceSelectingCubit>().selectList(
                                      key: widget.selectionKey,
                                      provinces: provinces,
                                    );
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.all(14),
                                    child: const Text(
                                      'все',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final province = provinces[index - (widget.singleSelection ? 0 : 1)];
                            final selectedIndex =
                                selecteds?.indexWhere((e) => e.id == province.id) ?? -1;
                            final isSelected = selectedIndex != -1;

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.black.withOpacity(0.06),
                                highlightColor: Colors.black.withOpacity(0.03),
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  context.read<ProvinceSelectingCubit>().selectProvince(
                                    key: widget.selectionKey,
                                    province: province,
                                    singleSelection: widget.singleSelection,
                                  );
                                },
                                child: Ink(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        province.name.tk ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      if (isSelected)
                                        const Icon(Icons.check, color: Color(0xFF969696), size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          splashColor: Colors.white.withOpacity(0.22),
                          highlightColor: Colors.white.withOpacity(0.10),
                          onTap: () {
                            HapticFeedback.mediumImpact();

                            Future.delayed(const Duration(milliseconds: 120), () {
                              Go.pop();
                            });
                          },
                          child: Ink(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Col.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: Text('Сохранить', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
