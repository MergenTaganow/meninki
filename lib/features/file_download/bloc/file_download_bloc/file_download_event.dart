part of 'file_download_bloc.dart';

@immutable
sealed class FileDownloadEvent {}

class DownloadFile extends FileDownloadEvent {
  final MeninkiFile file;
  DownloadFile(this.file);
}
