import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:meninki/features/store/widgets/store_background_color_selection.dart';
import '../../../core/helpers.dart';
import '../../reels/model/reels.dart';
import '../../reels/widgets/reel_card.dart';

class StoreReelsList extends StatefulWidget {
  final Query query;
  final MarketColorScheme scheme;

  const StoreReelsList({required this.query, required this.scheme, super.key});

  @override
  State<StoreReelsList> createState() => _StoreReelsListState();
}

class _StoreReelsListState extends State<StoreReelsList> {
  List<Reel> reels = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lg = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<CurrentReelCubit, CurrentReelState>(
          listener: (context, state) {
            if (state is PaginateReels && state.reelType == ReelTypes.storeReels) {
              context.read<GetStoreReelsBloc>().add(ReelPag(query: widget.query));
            }
          },
        ),
        BlocListener<GetStoreReelsBloc, GetReelsState>(
          listener: (context, state) {
            if (state is GetReelSuccess) {
              context.read<CurrentReelCubit>().paginationCame(
                type: ReelTypes.storeReels,
                reels: state.reels,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<GetStoreReelsBloc, GetReelsState>(
        builder: (context, state) {
          if (state is GetReelLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetReelSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                reels = state.reels;
              });
            });
          }

          if (state is GetReelFailed) {
            return Text(state.message ?? lg.smthWentWrong);
          }

          return MasonryGridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 8,
            itemCount: reels.length,
            itemBuilder: (context, index) {
              return ReelCard(
                reel: reels[index],
                allReels: reels,
                primaryText: widget.scheme.textPrimary,
                reelType: ReelTypes.storeReels,
              );
            },
          );
        },
      ),
    );
  }
}
