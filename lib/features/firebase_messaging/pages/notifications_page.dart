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

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    context.read<GetNotificationsBloc>().add(GetNotifications());
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
          physics: const BouncingScrollPhysics(),
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
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return NotificationCard(state.notifications[index]);
                          },
                          separatorBuilder: (context, index) => Box(h: 10),
                          itemCount: state.notifications.length,
                        );
                      }
                      return Container();
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

class NotificationCard extends StatelessWidget {
  final NotificationMeninki notif;
  const NotificationCard(this.notif, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          NotifHelper.onTap(context: context, notif: notif);
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notif.title ?? '123',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (notif.image_url != null)
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: CachedNetworkImage(
                        imageUrl: "$baseUrl/public/${notif.image_url}",
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                ],
              ),
              Text(
                (notif.description ?? '').trim().replaceAll('  ', ' '),
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
