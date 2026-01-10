import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure.dart';
import '../../../reels/model/query.dart';
import '../../data/store_remote_data_source.dart';
import '../../models/market.dart';

part 'get_store_products_event.dart';
part 'get_store_products_state.dart';

///This cubit should be used only in home main it gets refers to different endpoint and shows different result
class GetStoreProductsBloc extends Bloc<GetStoreProductsEvent, GetStoreProductsState> {
  final StoreRemoteDataSource ds;
  List<Market> stores = [];
  int page = 1;
  int limit = 10;
  bool canPag = false;

  GetStoreProductsBloc(this.ds) : super(GetStoreProductsInitial()) {
    on<GetStoreProductsEvent>((event, emit) async {
      if (event is GetProductStores) {
        emit(GetProductStoresLoading());

        canPag = false;
        emit(await _getStores(event));
      }

      if (event is PaginateProductStores) {
        if (!canPag) return;

        emit(GetProductStoresPaginating());
        canPag = false;
        emit(await _paginate(event));
      }
    });
  }

  Future<GetStoreProductsState> _getStores(GetProductStores event) async {
    page = 1;
    final failOrNot = await ds.getStoresProducts(
      Query(limit: limit, offset: page, keyword: event.search ?? '', orderDirection: 'asc', orderBy: 'id'),
    );
    return failOrNot.fold((l) => GetProductStoresFailed(l), (r) {
      if (r.length == limit) canPag = true;
      stores = r;
      return GetProductStoresSuccess(stores);
    });
  }

  Future<GetStoreProductsState> _paginate(PaginateProductStores event) async {
    await Future.delayed(const Duration(milliseconds: 400));
    page++;
    final failOrNot = await ds.getStoresProducts(
      Query(offset: page, limit: limit, keyword: event.search, orderDirection: 'asc', orderBy: 'id'),
    );
    return failOrNot.fold((l) => GetProductStoresFailed(l), (r) {
      if (r.length == limit) canPag = true;
      stores.addAll(r);
      return GetProductStoresSuccess(stores);
    });
  }
}
