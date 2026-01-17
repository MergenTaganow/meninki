import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/reels/model/query.dart';
import '../../reels/model/reels.dart';
import '../../reels/widgets/reel_card.dart';

class StoreReelsList extends StatefulWidget {
  final Query query;
  const StoreReelsList({required this.query, super.key});

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
    return BlocBuilder<GetStoreReelsBloc, GetReelsState>(
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
          return Text("error");
        }

        return MasonryGridView.count(
          physics: BouncingScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 8,
          itemCount: reels.length,
          itemBuilder: (context, index) {
            return ReelCard(reel: reels[index], allReels: reels);
          },
        );
      },
    );
  }
}
