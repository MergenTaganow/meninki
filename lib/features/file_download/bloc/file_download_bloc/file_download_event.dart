part of 'file_download_bloc.dart';

@immutable
sealed class FileDownloadEvent {}

class DownloadFile extends FileDownloadEvent {
  final MeninkiFile file;
  DownloadFile(this.file);
}

class DownloadProgressUpdated extends FileDownloadEvent {
  final String taskId;
  final int progress;
  final DownloadTaskStatus status;

  DownloadProgressUpdated({required this.taskId, required this.progress, required this.status});
}

class PauseOrResumeDownload extends FileDownloadEvent {}

class Retry extends FileDownloadEvent {
  final DownloadQueueItem item;

  Retry({required this.item});
}
