import 'package:bloc/bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

part 'file_download_event.dart';
part 'file_download_state.dart';

class FileDownloadBloc extends Bloc<FileDownloadEvent, FileDownloadState> {
  FileDownloadBloc() : super(FileDownloadInitial()) {
    on<FileDownloadEvent>((event, emit) async {
      if (event is DownloadFile) {
        var directory = await getApplicationDocumentsDirectory();

        await FlutterDownloader.enqueue(
          url: '$baseUrl/public/${event.file.original_file}',
          savedDir: directory.path,
          showNotification: true, // show download progress in status bar (for Android)
          openFileFromNotification:
              true, // click on notification to open downloaded file (for Android)
        );
      }
    });
  }
}
