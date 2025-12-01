import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/home/bloc/get_profile_cubit/get_profile_cubit.dart';
import 'package:meninki/features/home/model/profile.dart';
import 'package:meninki/features/home/widgets/reels_list.dart';
import '../../../core/colors.dart';
import '../../../core/helpers.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProfileCubit, GetProfileState>(
      builder: (context, state) {
        if (state is GetProfileLoading) {
          return Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
        }
        if (state is GetProfileFailed) {
          return Text(state.failure.message ?? "error");
        }
        if (state is GetProfileSuccess) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<GetProfileCubit>().getMyProfile();
            },
            child: SingleChildScrollView(
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
                            profile_name_settings(state.profile),
                            Divider(height: 1, color: Color(0xFFF3F3F3), thickness: 1),
                            Padd(
                              pad: 10,
                              child: Row(
                                children: [
                                  Text("Уведомления"),
                                  Spacer(),
                                  Text("13"),
                                  Box(w: 10),
                                  Icon(Icons.navigate_next),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Box(h: 10),
                      Row(
                        children: [
                          Expanded(
                            child: card(
                              child: Padd(
                                ver: 10,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Подписчики"),
                                    Text(
                                      state.profile.followers_coun.toString(),
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Box(w: 10),
                          Expanded(
                            child: card(
                              child: Padd(
                                ver: 10,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Подписки"),
                                    Text(
                                      state.profile.following_count.toString(),
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Box(h: 10),
                      Row(
                        children: [
                          iconTextCardButton(icon: "bookMark", text: "Избранное"),
                          Box(w: 10),
                          iconTextCardButton(icon: "messages", text: "Сообщения"),
                          Box(w: 10),
                          iconTextCardButton(icon: "news", text: "Объявления"),
                        ],
                      ),
                      Padd(
                        top: 10,
                        child: SizedBox(
                          height: 140,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (index == (state.profile.markets?.length ?? 0)) {
                                return InkWell(
                                  onTap: () {
                                    Go.to(Routes.storeCreatePage);
                                  },
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
                                            border: Border.all(color: Color(0xFFF3F3F3), width: 2),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.add_circle_outline_sharp,
                                              color: Col.primary,
                                            ),
                                          ),
                                        ),
                                        Box(h: 10),
                                        Expanded(
                                          child: Text(
                                            "Добавить магазин",
                                            style: TextStyle(fontSize: 12),
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
                              return storeCircle(state.profile.markets![index]);
                            },
                            itemCount: (state.profile.markets?.length ?? 0) + 1,
                          ),
                        ),
                      ),
                      ReelsList(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget storeCircle(Market market) {
    return GestureDetector(
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
      child: GestureDetector(
        onTap: onTap,
        child: card(
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
          GestureDetector(
            onTap: () {
              Go.to(Routes.productDetailPage, argument: {"productId": 1});
            },
            child: Icon(Icons.settings, color: Col.primary),
          ),
        ],
      ),
    );
  }

  Widget card({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFF3F3F3)),
      ),
      child: child,
    );
  }
}
