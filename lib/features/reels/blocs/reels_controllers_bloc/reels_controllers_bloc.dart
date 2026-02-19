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
  final Set<int> _initializingIds = {};

  ReelsControllersBloc() : super(ReelsControllersLoading({})) {
    on<NewReels>(_onNewReels);
    on<ReelsControllersEvent>((event, emit) {});
  }

  Future<void> _onNewReels(NewReels event, Emitter<ReelsControllersState> emit) async {
    for (final reel in event.reels) {
      final isImage = (reel.file.mimetype ?? '').contains('image');

      if (isImage) continue;

      if (controllersMap.containsKey(reel.id)) continue;
      if (_initializingIds.contains(reel.id)) continue;

      _initializingIds.add(reel.id);
      _initController(reel);
    }
  }

  Future<void> _initController(Reel reel) async {
    try {
      final previewIndex = (reel.file.playlists ?? []).indexWhere((e) => e.contains('preview'));

      if (previewIndex == -1) return;

      final url = reel.file.playlists![previewIndex];

      final dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        "$baseUrl/public/$url",
        videoFormat: BetterPlayerVideoFormat.hls,
        useAsmsAudioTracks: false,
        useAsmsSubtitles: false,
        useAsmsTracks: false,
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 2000,
          maxBufferMs: 10000,
          bufferForPlaybackMs: 300,
          bufferForPlaybackAfterRebufferMs: 1000,
        ),
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
          maxCacheSize: 500 * 1024 * 1024,
          maxCacheFileSize: 50 * 1024 * 1024,
        ),
      );

      final controller = BetterPlayerController(
        const BetterPlayerConfiguration(
          fit: BoxFit.cover,
          looping: false,
          allowedScreenSleep: false,
          controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false),
        ),
        betterPlayerDataSource: dataSource,
      );

      await controller.setVolume(0);

      controllersMap[reel.id] = controller;

      // ✅ emit ONCE per controller
      emit(ReelsControllersReady(Map<int, BetterPlayerController>.from(controllersMap)));

      // 🔑 notify queue with ID only
      sl<ReelPlayingQueueCubit>().addReadyId(reel.id);
    } catch (e) {
      controllersMap.remove(reel.id);
      _initializingIds.remove(reel.id);
      debugPrint('Failed to init reel ${reel.id}: $e');
    } finally {
      // controllersMap.remove(reel.id);
      _initializingIds.remove(reel.id);
    }
  }

  @override
  Future<void> close() async {
    for (final controller in controllersMap.values) {
      controller.dispose(forceDispose: true);
    }
    controllersMap.clear();
    return super.close();
  }
}
