import 'package:flutter/material.dart';
import 'package:meninki/features/firebase_messaging/models/notification_meninki.dart';

import '../../core/go.dart';
import '../../core/injector.dart';
import '../../core/routes.dart';
import '../home/bloc/tab_navigation_cubit/tab_navigation_cubit.dart';
import '../orders/bloc/order_id_cubit/order_id_cubit.dart';
import '../reels/blocs/current_reel_cubit/current_reel_cubit.dart';
import '../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../reels/data/reels_remote_data_source.dart';
import '../store/bloc/get_market_by_id/get_market_by_id_cubit.dart';

class NotifHelper {
  static void onTap({required BuildContext context, required NotificationMeninki? notif}) async {
    print(notif?.type);

    if (notif?.id == null) return;
    int id = int.parse(notif?.id ?? '');

    switch (notif?.type) {
      // 1
      case NotifTypes.PRODUCT_APPROVED:
        Go.to(Routes.myProductDetailPage, argument: {'productId': id});
        break;

      // 2
      case NotifTypes.REELS_APPROVED:
        var request = await sl<ReelsRemoteDataSource>().reelById(id);
        request.fold((l) {}, (r) {
          sl<GetVerifiedReelsBloc>().add(SetAndGetReel(r));
          print("object {reel != null}");
          sl<CurrentReelCubit>().setCurrentReel(type: ReelTypes.homeLenta, reels: [r]);
          Go.to(
            Routes.reelScreen,
            argument: {"initialPosition": 0, "reelType": ReelTypes.homeLenta},
          );
        });
        // sl<TabNavigationCubit>().homeToProfilePage();
        break;

      // 3
      case NotifTypes.ORDER_CREATED:
        Go.to(Routes.ordersPage);
        break;

      // 4
      case NotifTypes.ORDER_ACCEPTED:
        Go.to(Routes.ordersPage);
        break;

      // 5
      case NotifTypes.ORDER_CANCELLED:
        Go.to(Routes.ordersPage);
        break;

      // 6
      case NotifTypes.MARKET_ORDER_CREATED:
        Go.to(Routes.marketOrdersPage, argument: {'marketId': id});
        break;

      // 7
      case NotifTypes.MARKET_APPROVED:
        sl<GetMarketByIdCubit>().getStoreById(id);
        Go.to(Routes.myStoreDetail);
        break;

      // 9
      case NotifTypes.MARKET_CREATED:
        sl<GetMarketByIdCubit>().getStoreById(id);
        Go.to(Routes.myStoreDetail);
        break;

      // 10
      case NotifTypes.REEL_CREATED:
        sl<TabNavigationCubit>().homeToProfilePage();
        break;

      // 11
      case NotifTypes.PRODUCT_CREATED:
        Go.to(Routes.myProductDetailPage, argument: {"productId": id});
        break;

      // 12
      case NotifTypes.ORDER_UPDATED:
        sl<OrderIdCubit>().getOrder(id);
        Go.to(Routes.orderDetailPage);
        break;

      // 13
      case NotifTypes.ORDER_REJECTED:
        sl<OrderIdCubit>().getOrder(id);
        Go.to(Routes.orderDetailPage);
        break;

      // 14
      case NotifTypes.ORDER_ITEM_DELIVERED:
        sl<OrderIdCubit>().getOrder(id);
        Go.to(Routes.orderDetailPage);
        break;

      // 15
      case NotifTypes.MARKET_ORDER_ITEM_DELIVERED:
        Go.to(Routes.marketOrdersPage, argument: {'marketId': id});
        break;

      // 16
      case NotifTypes.MARKET_ORDER_ITEM_CANCELLED:
        Go.to(Routes.marketOrdersPage, argument: {'marketId': id});
        break;

      // 17
      case NotifTypes.MARKET_ORDER_ITEM_REJECTED:
        Go.to(Routes.marketOrdersPage, argument: {'marketId': id});
        break;

      // 18
      case NotifTypes.MAKRET_ORDER_ITEM_READY_TO_DELIVERY:
        Go.to(Routes.marketOrdersPage, argument: {'marketId': id});
        break;

      // 19
      case NotifTypes.ITEM_READY_TO_DELIVERY:
        sl<OrderIdCubit>().getOrder(id);
        Go.to(Routes.orderDetailPage);
        break;

      // 20
      case NotifTypes.ITEM_REJECTED:
        sl<OrderIdCubit>().getOrder(id);
        Go.to(Routes.orderDetailPage);
        break;

      default:
    }
  }
}

class NotifTypes {
  static const String BIRTHDAY = 'birthday';
  static const String REELS_APPROVED = 'reels_approved';
  static const String ORDER_CREATED = 'order_created';
  static const String ORDER_ACCEPTED = 'order_accepted';
  static const String ORDER_CANCELLED = 'order_cancelled';
  static const String MARKET_ORDER_CREATED = 'market_order_created';
  static const String MARKET_APPROVED = 'market_approved';
  static const String PRODUCT_APPROVED = 'product_approved';
  static const String MARKET_CREATED = 'market_created';
  static const String REEL_CREATED = 'reel_created';
  static const String PRODUCT_CREATED = 'product_created';
  static const String ORDER_UPDATED = 'order_updated';
  static const String ORDER_REJECTED = 'order_rejected';
  static const String ORDER_ITEM_DELIVERED = 'order_item_delivered';
  static const String MARKET_ORDER_ITEM_DELIVERED = 'market_order_item_delivered';
  static const String MARKET_ORDER_ITEM_CANCELLED = 'market_order_item_cancelled';
  static const String MARKET_ORDER_ITEM_REJECTED = 'market_order_item_rejected';
  static const String MAKRET_ORDER_ITEM_READY_TO_DELIVERY = 'market_order_item_ready_to_delivery';
  static const String ITEM_READY_TO_DELIVERY = 'item_ready_to_delivery';
  static const String ITEM_REJECTED = 'item_rejected';
}
