import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../reels/model/meninki_file.dart';
import '../../reels/model/reels.dart';
import '../../reels/widgets/reel_card.dart';

class ProductReelsList extends StatefulWidget {
  final Query query;

  const ProductReelsList({required this.query, super.key});

  @override
  State<ProductReelsList> createState() => _ProductReelsListState();
}

class _ProductReelsListState extends State<ProductReelsList> {
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
            if (state is PaginateReels && state.reelType == ReelTypes.productReels) {
              context.read<GetProductReelsBloc>().add(ReelPag(query: widget.query));
            }
          },
        ),
        BlocListener<GetProductReelsBloc, GetReelsState>(
          listener: (context, state) {
            if (state is GetReelSuccess) {
              context.read<CurrentReelCubit>().paginationCame(
                type: ReelTypes.productReels,
                reels: state.reels,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<GetProductReelsBloc, GetReelsState>(
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
                return ReelCard(reel: reel, allReels: reels, reelType: ReelTypes.productReels);
              },
            ),
          );
          // if (state is ReelPagLoading) const CircularProgressIndicator(),
        },
      ),
    );
  }
}
