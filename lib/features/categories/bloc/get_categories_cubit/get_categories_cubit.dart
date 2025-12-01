import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/categories/models/category.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

part 'get_categories_state.dart';

class GetCategoriesCubit extends Cubit<GetCategoriesState> {
  ReelsRemoteDataSource ds;
  GetCategoriesCubit(this.ds) : super(GetCategoriesInitial());
  List<Category> categories = [];

  getCategories() async {
    emit.call(GetCategoriesLoading());
    if (categories.isNotEmpty) {
      emit.call(GetCategoriesSuccess(categories));
      return;
    }
    var failOrNot = await ds.getCategories();

    failOrNot.fold((l) => emit.call(GetCategoriesFailed(l)), (r) {
      categories = r;
      emit.call(GetCategoriesSuccess(categories));
    });
  }
}
