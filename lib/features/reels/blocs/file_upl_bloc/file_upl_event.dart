part of 'file_upl_bloc.dart';

@immutable
sealed class FileUplEvent {}

class UploadFile extends FileUplEvent {
  final File file;

  UploadFile(this.file);
}
