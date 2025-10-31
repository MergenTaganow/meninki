import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:video_player/video_player.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final List<String> videoUrls = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    'https://filesamples.com/samples/video/mp4/sample_640x360.mp4',
  ];
  late PreloadPageController _pageController;
  final Map<int, VideoPlayerController> _controllers = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PreloadPageController();
    _initController(0);
    _prefetch(1);
  }

  Future<void> _initController(int index) async {
    if (index < 0 || index >= videoUrls.length) return;
    if (_controllers.containsKey(index)) return;

    // Try cached file first
    final fileInfo = await DefaultCacheManager().getFileFromCache(videoUrls[index]);
    File? file;
    if (fileInfo != null) {
      file = fileInfo.file;
    } else {
      // If not cached, start background download but play network directly
      DefaultCacheManager().downloadFile(videoUrls[index]);
    }

    final controller =
        file != null
            ? VideoPlayerController.file(file)
            : VideoPlayerController.networkUrl(Uri.parse(videoUrls[index]));

    await controller.initialize();
    controller.setLooping(true);

    if (index == _currentIndex) {
      await controller.play();
    }

    _controllers[index] = controller;
    setState(() {});
  }

  void _onPageChanged(int index) async {
    _controllers[_currentIndex]?.pause();
    _currentIndex = index;

    await _initController(index);
    await _controllers[index]?.play();

    // Preload next
    if (index + 1 < videoUrls.length) {
      _prefetch(index + 1);
    }

    // Dispose controllers far from current to save memory
    final toRemove = _controllers.keys.where((i) => (i - index).abs() > 1).toList();
    for (var i in toRemove) {
      _controllers[i]?.dispose();
      _controllers.remove(i);
    }

    setState(() {});
  }

  Future<void> _prefetch(int index) async {
    if (index >= videoUrls.length) return;
    await DefaultCacheManager().downloadFile(videoUrls[index]);
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PreloadPageView.builder(
        controller: _pageController,
        preloadPagesCount: 2,
        scrollDirection: Axis.vertical,
        itemCount: videoUrls.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final ctrl = _controllers[index];
          if (ctrl == null || !ctrl.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }
          return FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: ctrl.value.size.width,
              height: ctrl.value.size.height,
              child: VideoPlayer(ctrl),
            ),
          );
        },
      ),
    );
  }
}
