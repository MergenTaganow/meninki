import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../reels/model/meninki_file.dart';
import '../../reels/model/query.dart';
import '../../reels/model/reels.dart';
import '../../reels/widgets/reel_card.dart';

class PublicUsersReelsList extends StatefulWidget {
  final int userId;

  const PublicUsersReelsList({required this.userId, super.key});

  @override
  State<PublicUsersReelsList> createState() => _PublicUsersReelsListState();
}

class _PublicUsersReelsListState extends State<PublicUsersReelsList> {
  List<Reel> reels = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CurrentReelCubit, CurrentReelState>(
          listener: (context, state) {
            if (state is PaginateReels && state.reelType == ReelTypes.userReels) {
              context.read<GetUsersReelsBloc>().add(ReelPag(query: Query(user_id: widget.userId)));
            }
          },
        ),
        BlocListener<GetUsersReelsBloc, GetReelsState>(
          listener: (context, state) {
            if (state is GetReelSuccess) {
              context.read<CurrentReelCubit>().paginationCame(
                type: ReelTypes.userReels,
                reels: state.reels,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<GetUsersReelsBloc, GetReelsState>(
        builder: (context, state) {
          final isLoading = state is GetReelLoading;
          final reels = state is GetReelSuccess ? state.reels : <Reel>[];

          final itemCount = isLoading ? 6 : reels.length;

          return Skeletonizer(
            enabled: isLoading,
            child: MasonryGridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 8,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final reel = isLoading ? Reel() : reels[index];
                return ReelCard(reel: reel, allReels: reels, reelType: ReelTypes.userReels);
              },
            ),
          );
          // if (state is ReelPagLoading) const CircularProgressIndicator(),
        },
      ),
    );
  }
}
