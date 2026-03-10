import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meninki/features/basket/data/basket_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../basket/models/basket_product.dart';
import '../../../reels/model/query.dart';

part 'get_market_orders_event.dart';
part 'get_market_orders_state.dart';

class GetMarketOrdersBloc extends Bloc<GetMarketOrdersEvent, GetMarketOrdersState> {
  final BasketRemoteDataSource ds;
  List<OrderProduct> orders = [];

  int page = 1;
  int limit = 20;
  bool canPag = false;
  Query? lastQuery;

  GetMarketOrdersBloc(this.ds) : super(GetMarketOrderInitial()) {
    on<GetMarketOrdersEvent>((event, emit) async {
      if (event is GetMarketOrder) {
        canPag = false;
        lastQuery = event.query;
        emit(GetMarketOrderLoading());
        emit(await _getOrders(event));
      }

      if (event is MarketOrderPag) {
        if (!canPag) return;

        canPag = false;
        emit(MarketOrderPagLoading(orders));
        emit(await _paginate(event));
      }

      if (event is ClearMarketOrders) {
        orders = [];
        page = 1;
        emit(GetMarketOrderInitial());
      }
    });
  }

  /// RefreshIndicator support
  Future<void> refresh() async {
    final completer = Completer<void>();

    late final StreamSubscription sub;
    sub = stream.listen((state) {
      if (state is GetMarketOrderSuccess || state is GetMarketOrderFailed) {
        completer.complete();
        sub.cancel();
      }
    });

    canPag = false;
    emit(await _getOrders(GetMarketOrder(lastQuery)));

    return completer.future;
  }

  Future<GetMarketOrdersState> _paginate(MarketOrderPag event) async {
    page += 1;

    final failOrNot = await ds.getMarketOrders(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderBy: 'id',
        orderDirection: 'desc',
      ),
    );

    return failOrNot.fold(
      (l) => GetMarketOrderFailed(message: l.message, statusCode: l.statusCode),
      (r) {
        orders.addAll(r);
        if (r.length == limit) canPag = true;
        return GetMarketOrderSuccess(orders, r.length == limit);
      },
    );
  }

  Future<GetMarketOrdersState> _getOrders(GetMarketOrder event) async {
    page = 1;

    final failOrNot = await ds.getMarketOrders(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderBy: 'id',
        orderDirection: 'desc',
      ),
    );

    return failOrNot.fold(
      (l) => GetMarketOrderFailed(message: l.message, statusCode: l.statusCode),
      (r) {
        if (r.length == limit) canPag = true;
        orders = r;
        return GetMarketOrderSuccess(r, r.length == limit);
      },
    );
  }
}
