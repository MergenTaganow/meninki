import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/colors.dart';
import '../bloc/file_download_bloc/file_download_bloc.dart';
import 'custom_overflow.dart';

class DownloadOverlay {
  static OverlayEntry? _currentEntry;
  static final _stateNotifier = ValueNotifier<DownloadUIState?>(null);

  static void show(BuildContext context, DownloadUIState state) {
    if (_currentEntry == null) {
      _currentEntry = OverlayEntry(
        builder:
            (context) => _DownloadOverlayWidget(
              stateNotifier: _stateNotifier,
              onClose: () {
                _currentEntry?.remove();
                _currentEntry = null;
                _stateNotifier.value = null;
              },
            ),
      );
      Overlay.of(context).insert(_currentEntry!);
    }
    _stateNotifier.value = state;
  }

  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
    _stateNotifier.value = null;
  }

  static void update(DownloadUIState state) {
    _stateNotifier.value = state;
  }
}

class _DownloadOverlayWidget extends StatefulWidget {
  final ValueNotifier<DownloadUIState?> stateNotifier;
  final VoidCallback onClose; // <-- add this

  const _DownloadOverlayWidget({
    required this.stateNotifier,
    required this.onClose, // <-- add this
  });

  @override
  State<_DownloadOverlayWidget> createState() => _DownloadOverlayWidgetState();
}

class _DownloadOverlayWidgetState extends State<_DownloadOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  DownloadQueueItem? curState;

  /// Animates the overlay out and then calls [widget.onClose].
  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileDownloadBloc, FileDownloadState>(
      builder: (context, state) {
        if (state is FileDownloading) {
          var index = state.queue.indexWhere(
            (e) => e.status == DownloadItemStatus.running || e.status == DownloadItemStatus.paused,
          );

          curState = index != -1 ? state.queue[index] : null;
        }
        return Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        (curState?.status == DownloadItemStatus.failed)
                            ? Border.all(color: Col.redTask)
                            : Border.all(color: Colors.white.withOpacity(0.8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: const Color(0xFF7A4267).withOpacity(0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            // Play / Pause / Retry button
                            GestureDetector(
                              onTap: () {
                                if (curState?.status == DownloadItemStatus.failed) {
                                  context.read<FileDownloadBloc>().add(Retry(item: curState!));
                                } else {
                                  context.read<FileDownloadBloc>().add(PauseOrResumeDownload());
                                  setState(() {});
                                }
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF7A4267),
                                      const Color(0xFF7A4267).withOpacity(0.85),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF7A4267).withOpacity(0.25),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  (curState?.status == DownloadItemStatus.failed)
                                      ? Icons.refresh
                                      : (curState?.status == DownloadItemStatus.paused)
                                      ? Icons.play_arrow_rounded
                                      : Icons.pause_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // File name + progress bar
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SmartEllipsisText(
                                    text: curState?.file.name ?? '',
                                    style: const TextStyle(
                                      color: Color(0xFF1A1A1A),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      letterSpacing: -0.2,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: (curState?.progress ?? 0) / 100,
                                        child: Container(
                                          height: 4,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0xFF7A4267),
                                                const Color(0xFF7A4267).withOpacity(0.85),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF7A4267).withOpacity(0.25),
                                                blurRadius: 3,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Percentage badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7A4267).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${(curState?.progress ?? 0)}%',
                                style: const TextStyle(
                                  color: Color(0xFF7A4267),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // ── Close button ──────────────────────────────
                            GestureDetector(
                              onTap: _dismiss,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DownloadUIState {
  final String fileName;
  final int progress;
  final bool isPaused;

  DownloadUIState({required this.fileName, required this.progress, required this.isPaused});
}
