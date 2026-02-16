import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meninki/features/product/data/product_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../reels/model/query.dart';
import '../../models/product.dart';

part 'get_products_event.dart';
part 'get_products_state.dart';

class GetProductsBloc extends Bloc<GetProductsEvent, GetProductsState> {
  final ProductRemoteDataSource ds;
  List<Product> products = [];

  int page = 1;
  int limit = 20;
  bool canPag = false;
  Query? lastQuery;

  GetProductsBloc(this.ds) : super(GetProductInitial()) {
    on<GetProductsEvent>((event, emit) async {
      if (event is GetProduct) {
        canPag = false;
        lastQuery = event.query;
        emit.call(GetProductLoading());
        emit.call(await _getProducts(event));
      }

      if (event is ProductPag) {
        if (!canPag) return;

        canPag = false;
        emit.call(ProductPagLoading(products));
        emit.call(await _paginate(event));
      }

      if (event is ClearProducts) {
        products = [];
        page = 1;
        emit.call(GetProductInitial());
      }
    });
  }

  /// This is what your RefreshIndicator will call
  Future<void> refresh() async {
    final completer = Completer<void>();

    // listen once for the next success or error state
    late final StreamSubscription sub;
    sub = stream.listen((state) {
      if (state is GetProductSuccess || state is GetProductFailed) {
        completer.complete();
        sub.cancel();
      }
    });

    canPag = false;
    emit(await _getProducts(GetProduct(lastQuery)));

    return completer.future;
  }

  Future<GetProductsState> _paginate(ProductPag event) async {
    page += 1;

    final failOrNot = await ds.getProducts(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        // sortAs: event.query?.sortAs ?? 'created_at',
        // sortBy: event.query?.sortBy ?? 'id',
      ),
    );

    return failOrNot.fold((l) => GetProductFailed(message: l.message, statusCode: l.statusCode), (
      r,
    ) {
      products.addAll(r);
      if (r.length == limit) canPag = true;
      return GetProductSuccess(products, r.length == limit);
    });
  }

  Future<GetProductsState> _getProducts(GetProduct event) async {
    page = 1;

    final failOrNot = await ds.getProducts(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        // sortAs: event.query?.sortAs ?? 'created_at',
        // sortBy: event.query?.sortBy ?? 'id',
      ),
    );

    return failOrNot.fold((l) => GetProductFailed(message: l.message, statusCode: l.statusCode), (
      r,
    ) {
      if (r.length == limit) canPag = true;
      products = r;
      return GetProductSuccess(r, r.length == limit);
    });
  }
}

class GetOneStoresProducts extends GetProductsBloc {
  GetOneStoresProducts(super.ds);
}

class GetDiscountProducts extends GetProductsBloc {
  GetDiscountProducts(super.ds);
}

class GetNewProducts extends GetProductsBloc {
  GetNewProducts(super.ds);
}

class GetRaitedProducts extends GetProductsBloc {
  GetRaitedProducts(super.ds);
}

class GetFavoriteProductsBloc extends GetProductsBloc {
  GetFavoriteProductsBloc(super.ds);
}
