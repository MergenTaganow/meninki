import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

part 'reel_playing_queue_state.dart';

class ReelPlayingQueueCubit extends Cubit<ReelPlayingQueueState> {
  Map<int, VideoPlayerController> controllers = {};
  List<int> readyQueue = [];
  int? currentPlayingId;
  int currentIndex = -1;
  ReelPlayingQueueCubit() : super(ReelPlaying({}));

  void addReady(Map<int, VideoPlayerController> item) {
    controllers.addAll(item);
    readyQueue.addAll(item.keys);

    // If nothing is playing, start first one automatically
    if (currentPlayingId == null) {
      playNext();
    } else {
      emit(ReelPlaying(controllers, currentPlayingId: currentPlayingId));
    }
  }

  void playNext() async {
    if (readyQueue.isEmpty) return;

    // Pause current
    if (currentPlayingId != null) {
      final prev = controllers[currentPlayingId];
      await prev?.pause();
      await prev?.seekTo(Duration.zero);
    }

    // Move to next (loop back to start)
    currentIndex = (currentIndex + 1) % readyQueue.length;
    currentPlayingId = readyQueue[currentIndex];
    final controller = controllers[currentPlayingId];

    if (controller == null) {
      controllers.remove(currentPlayingId);
      readyQueue.remove(currentIndex);
      playNext();
      return;
    }

    await controller.play();
    emit(ReelPlaying(controllers, currentPlayingId: currentPlayingId));

    // Listen for when this short ends
    controller.removeListener(() {});
    controller.addListener(() async {
      final value = controller.value;
      if (value.isInitialized && !value.isPlaying && value.position >= value.duration) {
        controller.removeListener(() {});
        playNext();
      }
    });
  }

  /// Dispose all controllers when closing
  @override
  Future<void> close() async {
    for (final c in controllers.values) {
      await c.dispose();
    }
    return super.close();
  }
}
