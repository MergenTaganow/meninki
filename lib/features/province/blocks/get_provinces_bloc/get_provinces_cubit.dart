import 'package:bloc/bloc.dart';
import 'package:meninki/features/product/data/product_remote_data_source.dart';
import 'package:meninki/features/province/models/province.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure.dart';

part 'get_provinces_state.dart';

class GetProvincesCubit extends Cubit<GetProvincesState> {
  final ProductRemoteDataSource ds;
  GetProvincesCubit(this.ds) : super(GetProvincesInitial());

  List<Province> provinces = [];

  Future<void> getProvinces() async {
    emit(GetProvincesLoading());

    // Return cached data if already fetched
    if (provinces.isNotEmpty) {
      emit(GetProvincesSuccess(provinces));
      return;
    }

    final failOrProvinces = await ds.getProvinces();

    failOrProvinces.fold((failure) => emit(GetProvincesFailed(failure)), (data) {
      provinces = data;
      emit(GetProvincesSuccess(provinces));
    });
  }
}
