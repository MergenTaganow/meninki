import 'package:better_player/better_player.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../../core/injector.dart';
import '../reels_controllers_bloc/reels_controllers_bloc.dart';

part 'reel_playing_queue_state.dart';

class ReelPlayingQueueCubit extends Cubit<ReelPlayingQueueState> {
  Map<int, BetterPlayerController> controllers = {};
  final List<int> readyQueue = [];
  int? currentPlayingId;
  int _currentIndex = -1;
  bool _isSwitching = false;

  ReelPlayingQueueCubit() : super(ReelPlaying());

  void addReadyId(int reelId) {
    if (readyQueue.contains(reelId)) return;

    readyQueue.add(reelId);

    if (currentPlayingId == null) {
      _playNextInternal();
    } else {
      emit(ReelPlaying(currentPlayingId: currentPlayingId));
    }
  }

  Future<void> playNext() async {
    if (_isSwitching) return;
    _isSwitching = true;
    await _playNextInternal();
    _isSwitching = false;
  }

  Future<void> _playNextInternal() async {
    if (readyQueue.isEmpty) {
      if (currentPlayingId != null) currentPlayingId = null;
      if (_currentIndex != -1) _currentIndex = -1;
      emit(ReelPlaying(currentPlayingId: currentPlayingId));
      return;
    }

    final controllersBloc = sl<ReelsControllersBloc>();

    // stop previous
    if (currentPlayingId != null) {
      final prev = controllersBloc.controllersMap[currentPlayingId];
      await prev?.pause();
      // await prev?.seekTo(Duration.zero);
      prev?.removeEventsListener(_onPlayerEvent);
    }

    _currentIndex = (_currentIndex + 1) % readyQueue.length;
    currentPlayingId = readyQueue[_currentIndex];

    final controller = controllersBloc.controllersMap[currentPlayingId];


    if (controller == null) {
      readyQueue.removeAt(_currentIndex);
      _currentIndex--;
      return _playNextInternal();
    }

    // if (controller.videoPlayerController?.value.initialized != true) {
    //   print("found that it is not initialized");
    //   readyQueue.removeAt(_currentIndex);
    //   _currentIndex--;
    //   return _playNextInternal();
    // }

    controller.addEventsListener(_onPlayerEvent);

    if (kReleaseMode) {
      await controller.play();
    }


    emit(ReelPlaying(currentPlayingId: currentPlayingId));
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    final controller = sl<ReelsControllersBloc>().controllersMap[currentPlayingId];
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.initialized:
        controller?.setOverriddenAspectRatio(controller.videoPlayerController!.value.aspectRatio);
        break;

      case BetterPlayerEventType.finished:
        playNext();
        break;

      case BetterPlayerEventType.play:
      case BetterPlayerEventType.bufferingStart:
        // optional logging
        break;

      case BetterPlayerEventType.exception:
        // 🚨 THIS IS CRITICAL
        _handleFailedController(currentPlayingId!);
        break;

      default:
        break;
    }
  }

  void _handleFailedController(int reelId) {
    final controller = sl<ReelsControllersBloc>().controllersMap[currentPlayingId];
    controller?.dispose(forceDispose: true);

    readyQueue.remove(reelId);

    if (currentPlayingId == reelId) {
      currentPlayingId = null;
      playNext();
    }

    emit(ReelPlaying(currentPlayingId: currentPlayingId));
  }

  /// Dispose all controllers when closing
  @override
  Future<void> close() async {
    for (final c in controllers.values) {
      c.dispose(forceDispose: true);
    }
    return super.close();
  }
}
