import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/reels/blocs/file_processing_cubit/file_processing_cubit.dart';
import 'package:meninki/features/reels/blocs/get_my_reels_bloc/get_my_reels_bloc.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../reels/model/meninki_file.dart';
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
      child: BlocBuilder<GetMyReelsBloc, GetMyReelsState>(
        builder: (context, state) {
          final isLoading = state is GetMyReelLoading;
          final reels = state is GetMyReelSuccess ? state.reels : <Reel>[];

          final itemCount = isLoading ? 6 : reels.length;
          // final isLoading = state is GetReelLoading;
          // final itemCount = isLoading ? 6 : reels.length;

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
      ),
    );
  }
}
