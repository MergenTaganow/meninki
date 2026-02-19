import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/home/bloc/get_profile_cubit/get_profile_cubit.dart';
import 'package:meninki/features/home/model/profile.dart';
import 'package:meninki/features/home/widgets/reels_list.dart';
import 'package:meninki/features/reels/model/query.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/colors.dart';
import '../../../core/helpers.dart';
import '../../reels/blocs/get_my_reels_bloc/get_my_reels_bloc.dart';
import '../../store/bloc/get_market_by_id/get_market_by_id_cubit.dart';
import '../../store/models/market.dart';

class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({super.key});

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  @override
  void initState() {
    context.read<GetProfileCubit>().getMyProfile();
    context.read<GetMyReelsBloc>().add(GetMyReel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return BlocBuilder<GetProfileCubit, GetProfileState>(
      builder: (context, state) {
        final isLoading = state is GetProfileLoading;

        final profile =
            state is GetProfileSuccess
                ? state.profile
                : Profile(id: 999); // <-- create a fake model for skeleton

        return Skeletonizer(
          enabled: isLoading,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  context.read<GetMyReelsBloc>().refresh();
                  await context.read<GetProfileCubit>().refreshMyProfile();
                },
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Color(0xFFFBFBFB),
                  child: Padd(
                    hor: 14,
                    ver: 20,
                    child: Column(
                      children: [
                        card(
                          child: Column(
                            children: [
                              profile_name_settings(profile),
                              const Divider(height: 1, color: Color(0xFFF3F3F3), thickness: 1),
                              Padd(
                                pad: 10,
                                child: Row(
                                  children: [
                                    Text(lg.notifications),
                                    const Spacer(),
                                    Text("13"),
                                    const Box(w: 10),
                                    const Icon(Icons.navigate_next),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Box(h: 10),
                        Row(
                          children: [
                            Expanded(
                              child: card(
                                child: Padd(
                                  ver: 10,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(lg.followers),
                                      Text(
                                        profile.followers_coun.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Box(w: 10),
                            Expanded(
                              child: card(
                                child: Padd(
                                  ver: 10,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(lg.following),
                                      Text(
                                        profile.following_count.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Box(h: 10),
                        Row(
                          children: [
                            iconTextCardButton(
                              icon: "bookMark",
                              text: lg.favorites,
                              onTap: () async {
                                await Future.delayed(const Duration(milliseconds: 120));
                                Go.to(Routes.favoritesPage);
                              },
                            ),
                            const Box(w: 10),
                            iconTextCardButton(icon: "messages", text: lg.messages),
                            const Box(w: 10),
                            iconTextCardButton(
                              icon: "news",
                              text: lg.ads,
                              onTap: () async {
                                await Future.delayed(const Duration(milliseconds: 120));
                                Go.to(Routes.myAddsPage);
                              },
                            ),
                          ],
                        ),
                        Padd(
                          top: 10,
                          child: SizedBox(
                            height: 140,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: (profile.markets?.length ?? 0) + 1,
                              itemBuilder: (context, index) {
                                if (index == (profile.markets?.length ?? 0)) {
                                  return InkWell(
                                    onTap: () => Go.to(Routes.storeCreatePage),
                                    child: SizedBox(
                                      width: 100,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                color: const Color(0xFFF3F3F3),
                                                width: 2,
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add_circle_outline_sharp,
                                                color: Col.primary,
                                              ),
                                            ),
                                          ),
                                          const Box(h: 10),
                                          Expanded(
                                            child: Text(
                                              lg.addStore,
                                              style: const TextStyle(fontSize: 12),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return storeCircle(profile.markets![index]);
                              },
                            ),
                          ),
                        ),
                        MyReelsList(query: Query(user_id: profile.id)),
                        const Box(h: 90),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget storeCircle(Market market) {
    return InkWell(
      onTap: () {
        context.read<GetMarketByIdCubit>().getStoreById(market.id);
        Go.to(Routes.myStoreDetail);
      },
      child: SizedBox(
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                child: Image.network(
                  '$baseUrl/public/${market.cover_image?.resizedFiles?.small}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Box(h: 10),
            Expanded(
              child: Text(
                market.name,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget iconTextCardButton({required String icon, required String text, void Function()? onTap}) {
    return Expanded(
      child: card(
        onTap: onTap,
        child: Padd(
          ver: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Svvg.asset(icon),
              Box(h: 4),
              Text(text, style: TextStyle(color: Col.primary, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget profile_name_settings(Profile profile) {
    return Padd(
      pad: 10,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
          ),
          Box(w: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${profile.first_name} ${profile.last_name}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text("@${profile.username}", style: TextStyle(color: Color(0xFF474747))),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Go.to(Routes.settingsPage);
            },
            child: Icon(Icons.settings, color: Col.primary),
          ),
        ],
      ),
    );
  }

  Widget card({required Widget child, VoidCallback? onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.black.withOpacity(0.08),
        highlightColor: Colors.black.withOpacity(0.04),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFFF3F3F3)),
          ),
          child: child,
        ),
      ),
    );
  }
}
