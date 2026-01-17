import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/reels/model/query.dart';
import '../../../core/colors.dart';
import '../../../core/helpers.dart';
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
    return BlocBuilder<GetProductReelsBloc, GetReelsState>(
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

        return RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () async {
            context.read<GetProductReelsBloc>().add(GetReel(widget.query));
          },
          child: MasonryGridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 8,
            itemCount: reels.length,
            itemBuilder: (context, index) {
              return ReelCard(reel: reels[index], allReels: reels);
            },
          ),
        );
        // if (state is ReelPagLoading) const CircularProgressIndicator(),
      },
    );
  }
}
