import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../reels/model/query.dart';
import '../../data/product_remote_data_source.dart';
import '../../models/product_atribute.dart';

part 'get_product_attributes_event.dart';
part 'get_product_attributes_state.dart';

class GetProductAttributesBloc extends Bloc<GetProductAttributesEvent, GetProductAttributesState> {
  final ProductRemoteDataSource ds;
  List<ProductAttribute> productAttributes = [];

  int page = 1;
  int limit = 15;
  bool canPag = false;

  GetProductAttributesBloc(this.ds) : super(GetProductAttributeInitial()) {
    on<GetProductAttributesEvent>((event, emit) async {
      if (event is GetProductAttribute) {
        if (event.query == null && productAttributes.isNotEmpty) {
          emit.call(GetProductAttributeSuccess(productAttributes, true));
          return;
        }

        canPag = false;
        emit.call(GetProductAttributeLoading());
        emit.call(await _getProductAttributes(event));
      }

      if (event is ProductAttributePag) {
        if (!canPag) return;

        canPag = false;
        emit.call(ProductAttributePagLoading(productAttributes));
        emit.call(await _paginate(event));
      }
    });
  }

  // ✅ PAGINATION
  Future<GetProductAttributesState> _paginate(ProductAttributePag event) async {
    page += 1;

    final failOrNot = await ds.getAttributes(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        sortAs: event.query?.orderDirection ?? 'asc',
        sortBy: event.query?.orderBy ?? 'id',
      ),
    );

    return failOrNot.fold(
      (l) => GetProductAttributeFailed(message: l.message, statusCode: l.statusCode),
      (r) {
        productAttributes.addAll(r);
        if (r.length == limit) canPag = true;

        return GetProductAttributeSuccess(productAttributes, r.length == limit);
      },
    );
  }

  // ✅ INITIAL LOAD
  Future<GetProductAttributesState> _getProductAttributes(GetProductAttribute event) async {
    page = 1;

    final failOrNot = await ds.getAttributes(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        sortAs: event.query?.orderDirection ?? 'asc',
        sortBy: event.query?.orderBy ?? 'id',
      ),
    );

    return failOrNot.fold(
      (l) => GetProductAttributeFailed(message: l.message, statusCode: l.statusCode),
      (r) {
        if (r.length == limit) canPag = true;
        productAttributes = r;

        return GetProductAttributeSuccess(r, r.length == limit);
      },
    );
  }
}
