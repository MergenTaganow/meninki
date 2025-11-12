import 'package:bloc/bloc.dart';
import 'package:meninki/features/reels/blocs/reel_playin_queue_cubit/reel_playing_queue_cubit.dart';
import 'package:meninki/features/reels/model/reels.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/api.dart';
import '../../../../core/injector.dart';

part 'reels_controllers_event.dart';
part 'reels_controllers_state.dart';

class ReelsControllersBloc extends Bloc<ReelsControllersEvent, ReelsControllersState> {
  Map<int, VideoPlayerController> controllersMap = {};
  ReelsControllersBloc() : super(ReelsControllersLoading({})) {
    on<ReelsControllersEvent>((event, emit) {
      if (event is NewReels) {
        for (var i in event.reels) {
          if (controllersMap.containsKey(i.id) == false) {
            _initController(i);
          }
        }
      }
    });
  }
  Future<void> _initController(Reel reel) async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse("$baseUrl/public/${reel.file.original_file}/${reel.file.video_chunks?.first}"),
    );
    // Save immediately
    controllersMap[reel.id] = controller;

    // Wait until ready
    await controller.initialize();
    await controller.setVolume(0);

    sl<ReelPlayingQueueCubit>().addReady({reel.id: controller});

    emit.call(ReelsControllersLoading(controllersMap));
  }

  @override
  Future<void> close() async {
    for (final c in controllersMap.values) {
      await c.dispose();
    }
    return super.close();
  }
}
