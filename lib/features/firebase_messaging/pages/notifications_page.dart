import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/firebase_messaging/bloc/get_notifcations_cubit/get_notifications_bloc.dart';
import 'package:meninki/features/firebase_messaging/models/notification_meninki.dart';
import 'package:meninki/features/firebase_messaging/notif_helper.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';

import '../widgets/notification_card.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  ScrollController controller = ScrollController();

  List<NotificationMeninki> notifications = [];

  @override
  void initState() {
    context.read<GetNotificationsBloc>().add(GetNotifications());
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        context.read<GetNotificationsBloc>().add(NotificationsPag());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(lg.notifications)),
      body: Padd(
        hor: 12,
        ver: 20,
        child: CustomScrollView(
          controller: controller,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                await context.read<GetNotificationsBloc>().refresh();
              },
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  BlocBuilder<GetNotificationsBloc, GetNotificationsState>(
                    builder: (context, state) {
                      if (state is GetNotificationsLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is GetNotificationsSuccess) {
                        notifications = state.notifications;
                      }
                      return Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return NotificationCard(notifications[index]);
                            },
                            separatorBuilder: (context, index) => Box(h: 10),
                            itemCount: notifications.length,
                          ),
                          if (state is NotificationsPagLoading)
                            Padd(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
