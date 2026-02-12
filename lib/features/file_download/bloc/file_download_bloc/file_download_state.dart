part of 'file_download_bloc.dart';

@immutable
sealed class FileDownloadState {}

final class FileDownloadInitial extends FileDownloadState {}

final class FileDownloading extends FileDownloadState {
  final MeninkiFile file;
  final String downloadingPath;
  final int progress;
  final bool isPaused;
  final bool isFailed;
  FileDownloading({
    required this.file,
    required this.downloadingPath,
    required this.progress,
    required this.isPaused,
    required this.isFailed,
  });

  FileDownloading copyWith({
    MeninkiFile? file,
    String? downloadingPath,
    int? progress,
    bool? isPaused,
    bool? isFailed,
  }) {
    return FileDownloading(
      file: file ?? this.file,
      downloadingPath: downloadingPath ?? this.downloadingPath,
      progress: progress ?? this.progress,
      isPaused: isPaused ?? this.isPaused,
      isFailed: isFailed ?? this.isFailed,
    );
  }
}

final class FileDownloadingIsBusy extends FileDownloadState {}

final class FileAlreadyExists extends FileDownloadState {}
