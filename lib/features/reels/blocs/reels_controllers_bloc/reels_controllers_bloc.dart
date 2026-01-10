import 'package:better_player/better_player.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meninki/features/reels/blocs/reel_playin_queue_cubit/reel_playing_queue_cubit.dart';
import 'package:meninki/features/reels/model/reels.dart';
import 'package:meta/meta.dart';

import '../../../../core/api.dart';
import '../../../../core/injector.dart';

part 'reels_controllers_event.dart';
part 'reels_controllers_state.dart';

class ReelsControllersBloc extends Bloc<ReelsControllersEvent, ReelsControllersState> {
  Map<int, BetterPlayerController> controllersMap = {};
  ReelsControllersBloc() : super(ReelsControllersLoading({})) {
    on<ReelsControllersEvent>((event, emit) {
      if (event is NewReels) {
        for (var i in event.reels) {
          ///Todo later need to control image reels
          if (controllersMap.containsKey(i.id) == false &&
              (!(i.file.mimetype ?? '').contains('image'))) {
            _initController(i);
          }
        }
      }
    });
  }
  Future<void> _initController(Reel reel) async {
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "$baseUrl/public/${reel.file.video_chunks?.first}",
      useAsmsAudioTracks: false,
      useAsmsSubtitles: false,
      useAsmsTracks: false,
      bufferingConfiguration: BetterPlayerBufferingConfiguration(
        minBufferMs: 2000, // lower → faster start
        maxBufferMs: 10000, // enough for stability
        bufferForPlaybackMs: 300, // super fast start
        bufferForPlaybackAfterRebufferMs: 1000,
      ),
      cacheConfiguration: BetterPlayerCacheConfiguration(
        useCache: true,
        maxCacheSize: 500 * 1024 * 1024, // 50 MB
        maxCacheFileSize: 50 * 1024 * 1024, // 10 MB per file
      ),
    );

    final betterPlayerConfiguration = BetterPlayerConfiguration(
      looping: false,
      allowedScreenSleep: false,
      controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false),
      // fit: BoxFit.cover,
    );

    final controller = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: dataSource,
    );
    // Save immediately
    controllersMap[reel.id] = controller;

    // Wait until ready
    await controller.setVolume(0);

    // sl<ReelPlayingQueueCubit>().addReady({reel.id: controller});

    emit.call(ReelsControllersLoading(controllersMap));
  }

  @override
  Future<void> close() async {
    for (final c in controllersMap.values) {
      c.dispose(forceDispose: true);
    }
    return super.close();
  }
}
