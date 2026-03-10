import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/colors.dart';
import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../bloc/get_regions_bloc/get_regions_bloc.dart';
import '../bloc/region_selection_cubit/region_selecting_cubit.dart';
import '../models/region.dart';

class RegionSelectingPage extends StatefulWidget {
  final String selectionKey;
  final bool singleSelection;

  const RegionSelectingPage({super.key, this.singleSelection = false, required this.selectionKey});

  @override
  State<RegionSelectingPage> createState() => _RegionSelectingPageState();
}

class _RegionSelectingPageState extends State<RegionSelectingPage> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch regions when page opens
    context.read<GetRegionsBloc>().add(GetRegion());

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        context.read<GetRegionsBloc>().add(RegionPag());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AppLocalizations.of(context)!.region",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Padd(
        pad: 10,
        child: BlocBuilder<GetRegionsBloc, GetRegionsState>(
          builder: (context, state) {
            if (state is GetRegionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetRegionFailed) {
              return Center(child: Text(state.message ?? AppLocalizations.of(context)!.error));
            }

            if (state is GetRegionSuccess) {
              final regions = state.regions;

              return BlocBuilder<RegionSelectingCubit, RegionSelectingState>(
                builder: (context, selectState) {
                  List<Region>? selecteds;

                  if (selectState is RegionSelectingSuccess) {
                    selecteds = selectState.selectedMap[widget.selectionKey] ?? [];
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          controller: controller,
                          itemCount: regions.length + (widget.singleSelection ? 0 : 1),
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

                                    context.read<RegionSelectingCubit>().selectList(
                                      key: widget.selectionKey,
                                      regions: regions,
                                    );
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.all(14),
                                    child: Text(
                                      AppLocalizations.of(context)!.all,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final region = regions[index - (widget.singleSelection ? 0 : 1)];

                            final selectedIndex =
                                selecteds?.indexWhere((e) => e.id == region.id) ?? -1;

                            final isSelected = selectedIndex != -1;

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.black.withOpacity(0.06),
                                highlightColor: Colors.black.withOpacity(0.03),
                                onTap: () {
                                  HapticFeedback.selectionClick();

                                  context.read<RegionSelectingCubit>().selectRegion(
                                    key: widget.selectionKey,
                                    region: region,
                                    singleSelection: widget.singleSelection,
                                  );
                                },
                                child: Ink(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        region.name?.trans(context) ?? '',
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
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.save,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
