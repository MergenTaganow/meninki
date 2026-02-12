part of 'file_download_bloc.dart';

@immutable
sealed class FileDownloadEvent {}

class DownloadFile extends FileDownloadEvent {
  final MeninkiFile file;
  DownloadFile(this.file);
}

class DownloadProgressUpdated extends FileDownloadEvent {
  final int progress;
  final DownloadTaskStatus status;

  DownloadProgressUpdated({
    required this.progress,
    required this.status,
  });
}

class PauseOrResumeDownload extends FileDownloadEvent {}

class Retry extends FileDownloadEvent {}