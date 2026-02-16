import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../../reels/model/meninki_file.dart';
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
              // Use dummy reel when loading to avoid index errors
              final reel =
                  isLoading
                      ? Reel(
                        id: index,
                        type: '',
                        is_active: false,
                        is_verified: false,
                        user_id: 0,
                        title: 'qwertyuiokjhgfds xhmhdtgsfad acsvdfhywqedsx  stgqd',
                        file: MeninkiFile(id: 0, name: '', original_file: ''),
                      )
                      : reels[index];
              return ReelCard(reel: reel, allReels: reels);
            },
          ),
        );
        // if (state is ReelPagLoading) const CircularProgressIndicator(),
      },
    );
  }
}
