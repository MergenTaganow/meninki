import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/colors.dart';
import '../../../core/helpers.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../../reels/model/reels.dart';
import '../../reels/widgets/reel_card.dart';

class ReelsList extends StatefulWidget {
  const ReelsList({super.key});

  @override
  State<ReelsList> createState() => _ReelsListState();
}

class _ReelsListState extends State<ReelsList> {
  List<Reel> reels = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetReelsBloc, GetReelsState>(
      builder: (context, state) {
        if (state is GetReelLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GetReelSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              reels = state.reels;
            });
          });
        }

        if (state is GetReelFailed) {
          // return ErrorPage(
          //   fl: state.fl,
          //   onRefresh: () {
          //     context.read<GetOrdersBloc>().add(RefreshLastOrders());
          //   },
          // );
          return Text("error");
        }

        if (reels.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Svvg.asset('_emptyy'),
              const Box(h: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Col.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: () {
                  context.read<GetReelsBloc>().add(GetReel());
                },
                child: SizedBox(
                  height: 45,
                  child: Center(
                    child: Padd(
                      hor: 10,
                      child: Text(
                        "lg.tryAgain",
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () async {
            context.read<GetReelsBloc>().add(GetReel());
          },
          child: MasonryGridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 8,
            itemCount: reels.length,
            itemBuilder: (context, index) {
              return ReelCard(reel: reels[index]);
            },
          ),
        );
        // if (state is ReelPagLoading) const CircularProgressIndicator(),
      },
    );
  }
}
