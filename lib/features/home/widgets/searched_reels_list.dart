import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../../reels/model/reels.dart';
import '../../reels/widgets/reel_card.dart';

class SearchedReelsList extends StatefulWidget {
  const SearchedReelsList({super.key});

  @override
  State<SearchedReelsList> createState() => _SearchedReelsListState();
}

class _SearchedReelsListState extends State<SearchedReelsList> {
  List<Reel> reels = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSearchedReelsBloc, GetReelsState>(
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

        return MasonryGridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 8,
          itemCount: reels.length,
          itemBuilder: (context, index) {
            return ReelCard(reel: reels[index], allReels: reels);
          },
        );
        // if (state is ReelPagLoading) const CircularProgressIndicator(),
      },
    );
  }
}
