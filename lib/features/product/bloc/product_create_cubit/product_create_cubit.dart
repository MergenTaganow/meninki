import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meta/meta.dart';

import '../../data/product_remote_data_source.dart';

part 'product_create_state.dart';

class ProductCreateCubit extends Cubit<ProductCreateState> {
  ProductRemoteDataSource ds;
  ProductCreateCubit(this.ds) : super(ProductCreateInitial());

  createProduct(Map<String, dynamic> data) async {
    emit.call(ProductCreateLoading());
    var failOrNot = await ds.createProduct(data);
    failOrNot.fold(
      (l) => emit.call(ProductCreateFailed(l)),
      (r) => emit.call(ProductCreateSuccess(r)),
    );
  }

  editProduct(int id, Map<String, dynamic> data) async {
    emit.call(ProductCreateLoading());
    var failOrNot = await ds.editProduct(id, data);
    failOrNot.fold(
      (l) => emit.call(ProductCreateFailed(l)),
      (r) => emit.call(ProductEditSuccess()),
    );
  }
}
