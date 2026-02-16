part of 'file_download_bloc.dart';

@immutable
sealed class FileDownloadState {}

final class FileDownloadInitial extends FileDownloadState {}

final class FileDownloading extends FileDownloadState {
  final List<DownloadQueueItem> queue;

  FileDownloading({required this.queue});

  FileDownloading copyWith({List<DownloadQueueItem>? queue}) {
    return FileDownloading(queue: queue ?? this.queue);
  }
}

final class FileQueued extends FileDownloadState {
  final MeninkiFile file;
  FileQueued({required this.file});
}

final class FileAlreadyExists extends FileDownloadState {}
