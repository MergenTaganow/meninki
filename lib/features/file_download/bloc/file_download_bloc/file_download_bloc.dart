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
  MeninkiFile? currentDownloadingFile;
  String? currentDownloadingPath;
  String? _currentTaskId;
  bool _isPaused = false;
  bool isFailed = false;

  FileDownloadBloc(this.downloadService) : super(FileDownloadInitial()) {
    on<DownloadFile>(_onDownloadFile);
    on<DownloadProgressUpdated>(_onProgressUpdated);
    on<PauseOrResumeDownload>(_onPauseOrResume);
    on<Retry>(_onRetry);
    _sub = downloadService.updates.listen((update) {
      add(DownloadProgressUpdated(progress: update.progress, status: update.status));
    });
  }

  void _onProgressUpdated(DownloadProgressUpdated event, Emitter<FileDownloadState> emit) {
    if (event.status == DownloadTaskStatus.running) {
      emit(
        FileDownloading(
          file: currentDownloadingFile!,
          downloadingPath: currentDownloadingPath!,
          progress: event.progress,
          isPaused: _isPaused,
          isFailed: isFailed,
        ),
      );
    }

    if (event.status == DownloadTaskStatus.complete) {
      MediaScanner.loadMedia(path: currentDownloadingPath);
      _reset();
      emit(FileDownloadInitial());
    }

    if (event.status == DownloadTaskStatus.failed) {
      if (state is FileDownloading) {
        emit((state as FileDownloading).copyWith(isFailed: true, isPaused: false));
      }
    }
  }

  Future<void> _onDownloadFile(DownloadFile event, Emitter<FileDownloadState> emit) async {
    if (_currentTaskId != null) {
      emit.call(FileDownloadingIsBusy());
      return;
    }

    if (await fileExists(event.file)) {
      print('File already exists: }');
      emit(FileAlreadyExists());
      emit(FileDownloadInitial());
      return;
    }

    final isImage =
        event.file.name!.endsWith('.jpg') ||
        event.file.name!.endsWith('.png') ||
        event.file.name!.endsWith('.jpeg');

    final directory = await getGalleryDirectory(isImage: isImage);

    currentDownloadingFile = event.file;
    currentDownloadingPath = directory.path;

    _currentTaskId = await FlutterDownloader.enqueue(
      url: '$baseUrl/public/${event.file.original_file}',
      savedDir: directory.path,
      fileName: event.file.name,
      showNotification: true,
      openFileFromNotification: true,
    );

    if (_currentTaskId == null) return;

    _isPaused = false;

    emit(
      FileDownloading(
        file: currentDownloadingFile!,
        downloadingPath: currentDownloadingPath!,
        progress: 0,
        isPaused: _isPaused,
        isFailed: isFailed,
      ),
    );
  }

  Future<void> _onPauseOrResume(
    PauseOrResumeDownload event,
    Emitter<FileDownloadState> emit,
  ) async {
    if (_currentTaskId == null) return;

    if (!_isPaused) {
      await FlutterDownloader.pause(taskId: _currentTaskId!);
      _isPaused = true;
    } else {
      final newTaskId = await FlutterDownloader.resume(taskId: _currentTaskId!);

      if (newTaskId != null) {
        _currentTaskId = newTaskId;
      }

      _isPaused = false;
    }
    if (state is FileDownloading) {
      emit((state as FileDownloading).copyWith(isPaused: _isPaused));
    }
  }

  Future<void> _onRetry(Retry event, Emitter<FileDownloadState> emit) async {
    if (_currentTaskId == null) return;

    final previousProgress = state is FileDownloading ? (state as FileDownloading).progress : 0;

    final newTaskId = await FlutterDownloader.retry(taskId: _currentTaskId!);

    if (newTaskId != null) {
      _currentTaskId = newTaskId;
      _isPaused = false;

      emit(
        (state as FileDownloading).copyWith(
          isFailed: false,
          isPaused: false,
          progress: previousProgress, // 🔥 important
        ),
      );
    }
  }

  void _reset() {
    _currentTaskId = null;
    _isPaused = false;
    currentDownloadingFile = null;
    currentDownloadingPath = null;
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
