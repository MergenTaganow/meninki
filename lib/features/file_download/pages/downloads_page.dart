import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/colors.dart';
import '../bloc/file_download_bloc/file_download_bloc.dart';
import '../widgets/custom_overflow.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Downloads Page
// ─────────────────────────────────────────────────────────────────────────────

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F8),
      body: BlocBuilder<FileDownloadBloc, FileDownloadState>(
        builder: (context, state) {
          if (state is! FileDownloading) {
            return const _EmptyDownloads();
          }

          final queue = state.queue;

          if (queue.isEmpty) {
            return const _EmptyDownloads();
          }

          // ── Partition into sections ──────────────────────────────────────
          final running = queue.where((e) => e.status == DownloadItemStatus.running).toList();
          final paused = queue.where((e) => e.status == DownloadItemStatus.paused).toList();
          final queued = queue.where((e) => e.status == DownloadItemStatus.queued).toList();
          final failed = queue.where((e) => e.status == DownloadItemStatus.failed).toList();
          final completed = queue.where((e) => e.status == DownloadItemStatus.completed).toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _DownloadsAppBar(queue: queue),

              // ── Summary strip ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _SummaryStrip(
                  running: running.length,
                  queued: queued.length,
                  failed: failed.length,
                  completed: completed.length,
                ),
              ),

              // ── Active / Paused ──────────────────────────────────────────
              if (running.isNotEmpty || paused.isNotEmpty) ...[
                _SectionHeader(
                  label: 'Active',
                  count: running.length + paused.length,
                  accentColor: const Color(0xFF7A4267),
                ),
                _DownloadSection(items: [...running, ...paused]),
              ],

              // ── Failed ───────────────────────────────────────────────────
              if (failed.isNotEmpty) ...[
                _SectionHeader(label: 'Failed', count: failed.length, accentColor: Col.redTask),
                _DownloadSection(items: failed),
              ],

              // ── Queued ───────────────────────────────────────────────────
              if (queued.isNotEmpty) ...[
                _SectionHeader(
                  label: 'Up next',
                  count: queued.length,
                  accentColor: const Color(0xFF9E7BAD),
                ),
                _DownloadSection(items: queued),
              ],

              // ── Completed ────────────────────────────────────────────────
              if (completed.isNotEmpty) ...[
                _SectionHeader(
                  label: 'Completed',
                  count: completed.length,
                  accentColor: const Color(0xFF4CAF50),
                ),
                _DownloadSection(items: completed),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App Bar
// ─────────────────────────────────────────────────────────────────────────────

class _DownloadsAppBar extends StatelessWidget {
  final List<DownloadQueueItem> queue;

  const _DownloadsAppBar({required this.queue});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 100,
      backgroundColor: const Color(0xFFF6F4F8),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF7A4267)),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
        title: const Text(
          'Downloads',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        background: Container(color: const Color(0xFFF6F4F8)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary strip
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryStrip extends StatelessWidget {
  final int running;
  final int queued;
  final int failed;
  final int completed;

  const _SummaryStrip({
    required this.running,
    required this.queued,
    required this.failed,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          _Chip(label: '$running active', color: const Color(0xFF7A4267)),
          const SizedBox(width: 8),
          if (failed > 0) ...[
            _Chip(label: '$failed failed', color: Col.redTask),
            const SizedBox(width: 8),
          ],
          _Chip(label: '$queued queued', color: const Color(0xFF9E7BAD)),
          const SizedBox(width: 8),
          _Chip(label: '$completed done', color: const Color(0xFF4CAF50)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  final Color accentColor;

  const _SectionHeader({required this.label, required this.count, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 14,
              decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(color: accentColor, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section list
// ─────────────────────────────────────────────────────────────────────────────

class _DownloadSection extends StatelessWidget {
  final List<DownloadQueueItem> items;

  const _DownloadSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _DownloadCard(item: items[index]),
          ),
          childCount: items.length,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Download Card  (mirrors the overlay's visual language)
// ─────────────────────────────────────────────────────────────────────────────

class _DownloadCard extends StatelessWidget {
  final DownloadQueueItem item;

  const _DownloadCard({required this.item});

  bool get _isFailed => item.status == DownloadItemStatus.failed;
  bool get _isPaused => item.status == DownloadItemStatus.paused;
  bool get _isQueued => item.status == DownloadItemStatus.queued;
  bool get _isCompleted => item.status == DownloadItemStatus.completed;

  Color get _accentColor {
    if (_isFailed) return Col.redTask;
    if (_isCompleted) return const Color(0xFF4CAF50);
    return const Color(0xFF7A4267);
  }

  IconData get _actionIcon {
    if (_isFailed) return Icons.refresh_rounded;
    if (_isPaused) return Icons.play_arrow_rounded;
    if (_isCompleted) return Icons.check_rounded;
    if (_isQueued) return Icons.schedule_rounded;
    return Icons.pause_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border:
            _isFailed
                ? Border.all(color: Col.redTask.withOpacity(0.4), width: 1)
                : Border.all(color: Colors.white.withOpacity(0.9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: _accentColor.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.88),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row ────────────────────────────────────────────────
                Row(
                  children: [
                    // Action button
                    GestureDetector(
                      onTap:
                          (_isCompleted || _isQueued)
                              ? null
                              : () {
                                if (_isFailed) {
                                  context.read<FileDownloadBloc>().add(Retry(item: item));
                                } else {
                                  context.read<FileDownloadBloc>().add(PauseOrResumeDownload());
                                }
                              },
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient:
                              (_isCompleted || _isQueued)
                                  ? null
                                  : LinearGradient(
                                    colors: [_accentColor, _accentColor.withOpacity(0.82)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                          color:
                              (_isCompleted || _isQueued) ? _accentColor.withOpacity(0.10) : null,
                          borderRadius: BorderRadius.circular(11),
                          boxShadow:
                              (_isCompleted || _isQueued)
                                  ? null
                                  : [
                                    BoxShadow(
                                      color: _accentColor.withOpacity(0.28),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                        ),
                        child: Icon(
                          _actionIcon,
                          color: (_isCompleted || _isQueued) ? _accentColor : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // File name + sub-info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SmartEllipsisText(
                            text: item.file.name ?? '',
                            style: const TextStyle(
                              color: Color(0xFF1A1A1A),
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                              letterSpacing: -0.2,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          _SubLabel(item: item),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Progress badge
                    _ProgressBadge(item: item, accentColor: _accentColor),
                  ],
                ),

                // ── Progress bar (hidden for queued / completed) ───────────
                if (!_isQueued && !_isCompleted) ...[
                  const SizedBox(height: 10),
                  _ProgressBar(
                    progress: item.progress,
                    accentColor: _accentColor,
                    isPaused: _isPaused,
                    isFailed: _isFailed,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-label under file name
// ─────────────────────────────────────────────────────────────────────────────

class _SubLabel extends StatelessWidget {
  final DownloadQueueItem item;

  const _SubLabel({required this.item});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    switch (item.status) {
      case DownloadItemStatus.running:
        text = 'Downloading…';
        color = const Color(0xFF7A4267);
        break;
      case DownloadItemStatus.paused:
        text = 'Paused';
        color = const Color(0xFFB07A30);
        break;
      case DownloadItemStatus.queued:
        text = 'Waiting in queue';
        color = Colors.grey.shade500;
        break;
      case DownloadItemStatus.failed:
        text = 'Download failed — tap to retry';
        color = Col.redTask;
        break;
      case DownloadItemStatus.completed:
        text = 'Saved to ${item.saveDir.split('/').last}';
        color = const Color(0xFF4CAF50);
        break;
    }

    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Progress badge (top-right of card)
// ─────────────────────────────────────────────────────────────────────────────

class _ProgressBadge extends StatelessWidget {
  final DownloadQueueItem item;
  final Color accentColor;

  const _ProgressBadge({required this.item, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final isQueued = item.status == DownloadItemStatus.queued;
    final isCompleted = item.status == DownloadItemStatus.completed;

    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withOpacity(0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF4CAF50)),
      );
    }

    if (isQueued) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.hourglass_top_rounded, size: 15, color: Colors.grey.shade400),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${item.progress}%',
        style: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Progress bar
// ─────────────────────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final int progress;
  final Color accentColor;
  final bool isPaused;
  final bool isFailed;

  const _ProgressBar({
    required this.progress,
    required this.accentColor,
    required this.isPaused,
    required this.isFailed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        FractionallySizedBox(
          widthFactor: (progress.clamp(0, 100)) / 100,
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isFailed
                        ? [Col.redTask, Col.redTask.withOpacity(0.7)]
                        : isPaused
                        ? [const Color(0xFFB07A30), const Color(0xFFB07A30).withOpacity(0.7)]
                        : [accentColor, accentColor.withOpacity(0.75)],
              ),
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyDownloads extends StatelessWidget {
  const _EmptyDownloads();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF7A4267).withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.download_rounded, size: 34, color: Color(0xFF7A4267)),
          ),
          const SizedBox(height: 16),
          const Text(
            'No downloads',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Files you download will appear here.',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
