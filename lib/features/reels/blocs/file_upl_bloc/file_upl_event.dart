part of 'file_upl_bloc.dart';

@immutable
sealed class FileUplEvent {}

class UploadFiles extends FileUplEvent {
  final List<File> files;
  final UploadingFileTypes type;

  UploadFiles(this.files, this.type);
}

class RemoveFile extends FileUplEvent {
  final File file;
  RemoveFile(this.file);
}

class RetryFile extends FileUplEvent {
  final File file;
  final UploadingFileTypes type;
  RetryFile(this.file, this.type);
}

class ClearUploading extends FileUplEvent {}
