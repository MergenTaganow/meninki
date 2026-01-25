import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:better_player/src/video_player/video_player.dart';


class InstaProgressBar extends StatefulWidget {
  final BetterPlayerController controller;

  const InstaProgressBar({super.key, required this.controller});

  @override
  State<InstaProgressBar> createState() => _InstaProgressBarState();
}

class _InstaProgressBarState extends State<InstaProgressBar> {
  bool _dragging = false;
  double? _dragProgress;

  VideoPlayerController get _video => widget.controller.videoPlayerController!;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _video,
      builder: (context, VideoPlayerValue value, _) {
        if (!value.initialized) return const SizedBox();

        final durationMs = value.duration!.inMilliseconds;
        final currentProgress = durationMs == 0 ? 0.0 : value.position.inMilliseconds / durationMs;

        final progress = _dragging && _dragProgress != null ? _dragProgress! : currentProgress;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,

          onHorizontalDragStart: (_) async {
            await widget.controller.pause();
            setState(() => _dragging = true);
          },

          onHorizontalDragUpdate: (details) {
            final box = context.findRenderObject() as RenderBox;
            final dx = details.localPosition.dx.clamp(0.0, box.size.width);

            setState(() {
              _dragProgress = dx / box.size.width;
            });
          },

          onHorizontalDragEnd: (_) async {
            await widget.controller.play();

            if (_dragProgress != null) {
              final seekMs = (_dragProgress! * durationMs).round();
              _video.seekTo(Duration(milliseconds: seekMs));
            }

            setState(() {
              _dragging = false;
              _dragProgress = null;
            });
          },

          onTapDown: (_) => setState(() => _dragging = true),

          onTapUp: (_) {
            if (_dragProgress != null) {
              final seekMs = (_dragProgress! * durationMs).round();
              _video.seekTo(Duration(milliseconds: seekMs));
            }
            setState(() {
              _dragging = false;
              _dragProgress = null;
            });
          },

          onTapCancel: () {
            setState(() {
              _dragging = false;
              _dragProgress = null;
            });
          },

          child: SizedBox(
            height: 28,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                height: _dragging ? 9 : 3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
