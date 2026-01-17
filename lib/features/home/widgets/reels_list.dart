import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/reels/blocs/file_processing_cubit/file_processing_cubit.dart';
import 'package:meninki/features/reels/blocs/get_my_reels_bloc/get_my_reels_bloc.dart';
import 'package:meninki/features/reels/model/query.dart';
import '../../reels/model/reels.dart';
import '../../reels/widgets/reel_card.dart';

class MyReelsList extends StatefulWidget {
  final Query query;

  const MyReelsList({required this.query, super.key});

  @override
  State<MyReelsList> createState() => _MyReelsListState();
}

class _MyReelsListState extends State<MyReelsList> {
  List<Reel> reels = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileProcessingCubit, FileProcessingState>(
      listener: (context, state) {
        if (state is FileProcessingUpdated) {
          var index = reels.indexWhere((element) => element.file.id == state.file.id);
          if (index != -1) {
            reels[index] = reels[index].copyWith(file: state.file);
            setState(() {});
          }
        }
      },
      child: BlocConsumer<GetMyReelsBloc, GetMyReelsState>(
        listener: (context, state) {
          // if (state is GetMyReelSuccess) {
          //   for (final reel in state.reels.where(
          //     (e) => e.file.status != 'ready' && e.file.status != 'failed',
          //   )) {
          //     sl<FileProcessingCubit>().trackFile(reel.file);
          //   }
          // }
        },
        builder: (context, state) {
          if (state is GetMyReelLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetMyReelSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                reels = state.reels;
              });
            });
          }

          if (state is GetMyReelFailed) {
            // return ErrorPage(
            //   fl: state.fl,
            //   onRefresh: () {
            //     context.read<GetOrdersBloc>().add(RefreshLastOrders());
            //   },
            // );
            return Text("error");
          }

          return RefreshIndicator(
            backgroundColor: Colors.white,
            onRefresh: () async {
              context.read<GetMyReelsBloc>().add(GetMyReel(widget.query));
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
      ),
    );
  }
}
