import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/helpers.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../../reels/model/meninki_file.dart';
import '../../reels/model/reels.dart';
import '../../reels/widgets/reel_card.dart';

class SearchedReelsList extends StatefulWidget {
  final Query query;

  const SearchedReelsList(this.query, {super.key});

  @override
  State<SearchedReelsList> createState() => _SearchedReelsListState();
}

class _SearchedReelsListState extends State<SearchedReelsList> {
  List<Reel> reels = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CurrentReelCubit, CurrentReelState>(
          listener: (context, state) {
            if (state is PaginateReels && state.reelType == ReelTypes.searchedReels) {
              context.read<GetSearchedReelsBloc>().add(ReelPag(query: widget.query));
            }
          },
        ),
        BlocListener<GetSearchedReelsBloc, GetReelsState>(
          listener: (context, state) {
            if (state is GetReelSuccess) {
              context.read<CurrentReelCubit>().paginationCame(
                type: ReelTypes.searchedReels,
                reels: state.reels,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<GetSearchedReelsBloc, GetReelsState>(
        builder: (context, state) {
          final isLoading = state is GetReelLoading;
          final reels = state is GetReelSuccess ? state.reels : <Reel>[];

          final itemCount = isLoading ? 6 : reels.length;

          return Skeletonizer(
            enabled: isLoading,
            child: Column(
              children: [
                MasonryGridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 8,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    // Use dummy reel when loading to avoid index errors
                    final reel = isLoading ? Reel() : reels[index];
                    return ReelCard(reel: reel, allReels: reels, reelType: ReelTypes.searchedReels);
                  },
                ),
                if (state is ReelPagLoading)
                  Padd(
                    ver: 10,
                    child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
          // if (state is ReelPagLoading) const CircularProgressIndicator(),
        },
      ),
    );
  }
}
