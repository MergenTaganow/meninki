import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/product/data/product_remote_data_source.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meta/meta.dart';

part 'get_product_by_id_state.dart';

class GetProductByIdCubit extends Cubit<GetProductByIdState> {
  final ProductRemoteDataSource ds;
  GetProductByIdCubit(this.ds) : super(GetProductByIdInitial());

  getPublicProduct(int id) async {
    emit.call(GetProductByIdLoading());
    var failOrNot = await ds.getPublicProductById(id);
    failOrNot.fold(
      (l) => emit.call(GetProductByIdFailed(l)),
      (r) => emit.call(GetProductByIdSuccess(r)),
    );
  }

  getMyProduct(int id) async {
    emit.call(GetProductByIdLoading());
    var failOrNot = await ds.getMyProductById(id);
    failOrNot.fold(
      (l) => emit.call(GetProductByIdFailed(l)),
      (r) => emit.call(GetProductByIdSuccess(r)),
    );
  }

  Future<void> refreshPublicProduct(int id) async {
    var failOrNot = await ds.getPublicProductById(id);
    failOrNot.fold(
      (l) => emit.call(GetProductByIdFailed(l)),
      (r) => emit.call(GetProductByIdSuccess(r)),
    );
  }

  Future<void> refreshMyProduct(int id) async {
    var failOrNot = await ds.getPublicProductById(id);
    failOrNot.fold(
      (l) => emit.call(GetProductByIdFailed(l)),
      (r) => emit.call(GetProductByIdSuccess(r)),
    );
  }
}
