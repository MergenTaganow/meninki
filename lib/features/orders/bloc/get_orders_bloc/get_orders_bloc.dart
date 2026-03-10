import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meninki/features/basket/data/basket_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../reels/model/query.dart';
import '../../model/order.dart';

part 'get_orders_event.dart';
part 'get_orders_state.dart';

class GetOrdersBloc extends Bloc<GetOrdersEvent, GetOrdersState> {
  final BasketRemoteDataSource ds;
  List<MeninkiOrder> orders = [];

  int page = 1;
  int limit = 20;
  bool canPag = false;
  Query? lastQuery;

  GetOrdersBloc(this.ds) : super(GetOrderInitial()) {
    on<GetOrdersEvent>((event, emit) async {
      if (event is GetOrder) {
        canPag = false;
        lastQuery = event.query;
        emit(GetOrderLoading());
        emit(await _getOrders(event));
      }

      if (event is OrderPag) {
        if (!canPag) return;

        canPag = false;
        emit(OrderPagLoading(orders));
        emit(await _paginate(event));
      }

      if (event is ClearOrders) {
        orders = [];
        page = 1;
        emit(GetOrderInitial());
      }
    });
  }

  /// RefreshIndicator support
  Future<void> refresh() async {
    final completer = Completer<void>();

    late final StreamSubscription sub;
    sub = stream.listen((state) {
      if (state is GetOrderSuccess || state is GetOrderFailed) {
        completer.complete();
        sub.cancel();
      }
    });

    canPag = false;
    emit(await _getOrders(GetOrder(lastQuery)));

    return completer.future;
  }

  Future<GetOrdersState> _paginate(OrderPag event) async {
    page += 1;

    final failOrNot = await ds.getOrders(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderBy: 'id',
        orderDirection: 'desc',
      ),
    );

    return failOrNot.fold((l) => GetOrderFailed(message: l.message, statusCode: l.statusCode), (r) {
      orders.addAll(r);
      if (r.length == limit) canPag = true;
      return GetOrderSuccess(orders, r.length == limit);
    });
  }

  Future<GetOrdersState> _getOrders(GetOrder event) async {
    page = 1;

    final failOrNot = await ds.getOrders(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderBy: 'id',
        orderDirection: 'desc',
      ),
    );

    return failOrNot.fold((l) => GetOrderFailed(message: l.message, statusCode: l.statusCode), (r) {
      if (r.length == limit) canPag = true;
      orders = r;
      return GetOrderSuccess(r, r.length == limit);
    });
  }
}