import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:media_scanner/media_scanner.dart';

class DownloadService {
  static const _portName = 'downloader_send_port';

  final ReceivePort _port = ReceivePort();

  Stream<DownloadUpdate> get updates => _controller.stream;
  final _controller = StreamController<DownloadUpdate>.broadcast();

  DownloadService() {
    _bindBackgroundIsolate();
  }

  void _bindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(_portName);

    IsolateNameServer.registerPortWithName(
      _port.sendPort,
      _portName,
    );

    _port.listen(_handleUpdate);
  }

  void _handleUpdate(dynamic data) async {
    final taskId = data[0] as String;
    final status = DownloadTaskStatus.fromInt(data[1] as int);
    final progress = data[2] as int;

    _controller.add(
      DownloadUpdate(taskId, status, progress),
    );

    if (status == DownloadTaskStatus.complete) {
      final tasks = await FlutterDownloader.loadTasks();
      final task = tasks?.firstWhere((e) => e.taskId == taskId);

      if (task != null) {
        final filePath = '${task.savedDir}/${task.filename}';

        // ✅ PERFECT PLACE
        MediaScanner.loadMedia(path: filePath);
      }
    }
  }

  void dispose() {
    IsolateNameServer.removePortNameMapping(_portName);
    _port.close();
    _controller.close();
  }
}

class DownloadUpdate {
  final String taskId;
  final DownloadTaskStatus status;
  final int progress;

  DownloadUpdate(this.taskId, this.status, this.progress);
}