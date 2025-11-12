import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import 'package:meninki/features/reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import 'package:meninki/features/reels/blocs/reel_playin_queue_cubit/reel_playing_queue_cubit.dart';
import 'package:meninki/features/reels/model/reels.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:video_player/video_player.dart';

import '../../../core/api.dart';
import '../widgets/users_profile.dart';

class ReelPage extends StatefulWidget {
  final Reel reel;
  const ReelPage({required this.reel, super.key});

  @override
  State<ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends State<ReelPage> {
  late PreloadPageController controller;

  @override
  void initState() {
    var position = context.read<GetReelsBloc>().reels.indexWhere((e) => e.id == widget.reel.id);
    print("position-____$position");
    print("position-____$position");
    print("position-____$position");
    print("position-____$position");
    controller = PreloadPageController(initialPage: position);
    context.read<CurrentReelCubit>().set(widget.reel);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetReelsBloc, GetReelsState>(
        builder: (context, state) {
          if (state is GetReelSuccess) {
            return PreloadPageView.builder(
              controller: controller,
              scrollDirection: Axis.vertical,
              preloadPagesCount: 3,
              itemCount: state.reels.length,
              onPageChanged: (index) {
                context.read<CurrentReelCubit>().set(state.reels[index]);
              },
              itemBuilder: (context, index) {
                return ReelWidget(reel: state.reels[index]);
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}

class ReelWidget extends StatefulWidget {
  final Reel reel;
  const ReelWidget({super.key, required this.reel});

  @override
  State<ReelWidget> createState() => _ReelWidgetState();
}

class _ReelWidgetState extends State<ReelWidget> {
  late VideoPlayerController controller;

  @override
  void initState() {
    controller =
        VideoPlayerController.networkUrl(
            Uri.parse("$baseUrl/public/${widget.reel.file.original_file}/playlist.m3u8"),
          )
          ..setLooping(true)
          ..initialize().then((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });
          });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentReelCubit, CurrentReelState>(
      builder: (context, state) {
        if (state is CurrentReelSuccess &&
            state.reel?.id == widget.reel.id &&
            controller.value.isInitialized &&
            (!controller.value.isPlaying)) {
          controller.play();
        }
        if (state is CurrentReelSuccess &&
            controller.value.isPlaying &&
            state.reel?.id != widget.reel.id) {
          controller.pause();
        }
        return Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        controller.value.isInitialized
                            ? AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller),
                            )
                            : Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padd(
                            pad: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '@reviewer2023',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ExpandableText(
                                  text:
                                      'Купила очки как у моего братюни! Совсем недорого, горбатая бабка продавала на ВДНХ. Качество хорошее, цвет точно такой жеnad osi asxn rxak',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padd(
                    hor: 10,
                    ver: 14,
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Box(w: 10),
                        Expanded(
                          child: Text(
                            widget.reel.title ?? '',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                        Icon(Icons.more_horiz, color: Color(0xFF969696)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5 - 30,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UsersProfile(),
                  iconCount(icon: "liked", count: "12K"), //'notLiked'
                  iconCount(icon: "comment", count: "12K"),
                  iconCount(icon: "repost", count: "12K"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Column iconCount({required String icon, required String count}) {
    return Column(
      children: [
        Box(h: 20),
        Svvg.asset(icon),
        Text(count, style: TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }
}
