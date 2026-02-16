import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';
import 'package:meta/meta.dart';
import '../../data/download_service.dart';

part 'file_download_event.dart';
part 'file_download_state.dart';

class FileDownloadBloc extends Bloc<FileDownloadEvent, FileDownloadState> {
  final DownloadService downloadService;
  late final StreamSubscription _sub;
  // MeninkiFile? currentDownloadingFile;
  // String? currentDownloadingPath;
  // String? _currentTaskId;
  final List<DownloadQueueItem> _items = [];
  bool isFailed = false;

  FileDownloadBloc(this.downloadService) : super(FileDownloadInitial()) {
    on<DownloadFile>(_onDownloadFile);
    on<DownloadProgressUpdated>(_onProgressUpdated);
    on<PauseOrResumeDownload>(_onPauseOrResume);
    on<Retry>(_onRetry);
    _sub = downloadService.updates.listen((update) {
      add(
        DownloadProgressUpdated(
          taskId: update.taskId,
          progress: update.progress,
          status: update.status,
        ),
      );
    });
  }

  DownloadQueueItem? get _currentRunning {
    try {
      return _items.firstWhere(
        (e) => e.status == DownloadItemStatus.running || e.status == DownloadItemStatus.paused,
      );
    } catch (_) {
      return null;
    }
  }

  bool get _hasRunning => _currentRunning != null;

  void _onProgressUpdated(DownloadProgressUpdated event, Emitter<FileDownloadState> emit) async {
    // Find item by taskId
    var index = _items.indexWhere((e) => e.taskId == event.taskId);

    final item = index != -1 ? _items[index] : null;

    if (item == null) return;

    if (event.status == DownloadTaskStatus.running) {
      item.progress = event.progress;
      item.status = DownloadItemStatus.running;

      emit(FileDownloading(queue: List.from(_items)));
    }

    if (event.status == DownloadTaskStatus.complete) {
      item.progress = 100;
      item.status = DownloadItemStatus.completed;

      MediaScanner.loadMedia(path: item.saveDir);

      emit(FileDownloadInitial());

      await _startNextQueued(emit);
    }

    if (event.status == DownloadTaskStatus.failed) {
      item.status = DownloadItemStatus.failed;

      emit(FileDownloading(queue: List.from(_items)));

      // 🔥 Start next queued automatically
      await _startNextQueued(emit);
    }
  }

  Future<void> _startNextQueued(Emitter<FileDownloadState> emit) async {
    if (_hasRunning) return;

    var index = _items.indexWhere((e) => e.status == DownloadItemStatus.queued);

    final next = index != -1 ? _items[index] : null;

    if (next != null) {
      await _startItem(next, emit);
    }
  }

  Future<void> _startItem(DownloadQueueItem item, Emitter<FileDownloadState> emit) async {
    final taskId = await FlutterDownloader.enqueue(
      url: '$baseUrl/public/${item.file.original_file}',
      savedDir: item.saveDir,
      fileName: item.file.name,
      showNotification: true,
      openFileFromNotification: true,
    );

    if (taskId == null) return;

    item.taskId = taskId;
    item.progress = 0;
    item.status = DownloadItemStatus.running;

    emit(FileDownloading(queue: List.from(_items)));
  }

  Future<void> _onDownloadFile(DownloadFile event, Emitter<FileDownloadState> emit) async {
    // 🔹 Prevent duplicate
    final alreadyExists = _items.any((e) => e.file.id == event.file.id);

    if (alreadyExists) {
      emit(FileAlreadyExists());
      return;
    }

    // final isImage =
    //     event.file.name!.endsWith('.jpg') ||
    //     event.file.name!.endsWith('.png') ||
    //     event.file.name!.endsWith('.jpeg');

    final directory = await getGalleryDirectory();

    final item = DownloadQueueItem(
      file: event.file,
      saveDir: directory.path,
      status: DownloadItemStatus.queued,
    );

    _items.add(item);

    // 🔹 If nothing running → start immediately
    if (!_hasRunning) {
      await _startItem(item, emit);
    } else {
      // 🔹 Emit queued state for snackbar/overlay
      emit(FileQueued(file: event.file));
      emit(FileDownloading(queue: List.from(_items)));
    }
  }

  Future<void> _onPauseOrResume(
    PauseOrResumeDownload event,
    Emitter<FileDownloadState> emit,
  ) async {
    final item = _currentRunning;
    if (item == null || item.taskId == null) return;

    if (item.status == DownloadItemStatus.paused) {
      final newTaskId = await FlutterDownloader.resume(taskId: item.taskId!);
      if (newTaskId != null) {
        item.taskId = newTaskId;
      }
      item.status = DownloadItemStatus.running;
    } else if (item.status == DownloadItemStatus.running) {
      await FlutterDownloader.pause(taskId: item.taskId!);
      item.status = DownloadItemStatus.paused;
    }

    emit(FileDownloading(queue: List.from(_items)));
  }

  Future<void> _onRetry(Retry event, Emitter<FileDownloadState> emit) async {
    final item = event.item;

    if (item.status != DownloadItemStatus.failed) return;

    // Reset
    item.taskId = null;
    item.progress = 0;
    item.status = DownloadItemStatus.queued;

    // Move to end of list
    _items.remove(item);
    _items.add(item);

    emit(FileDownloadInitial());

    await _startNextQueued(emit);
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}

class DownloadQueueItem {
  final MeninkiFile file;
  final String saveDir;

  String? taskId;
  int progress;
  DownloadItemStatus status;

  DownloadQueueItem({
    required this.file,
    required this.saveDir,
    this.taskId,
    this.progress = 0,
    this.status = DownloadItemStatus.queued,
  });
}

enum DownloadItemStatus { queued, running, paused, failed, completed }
