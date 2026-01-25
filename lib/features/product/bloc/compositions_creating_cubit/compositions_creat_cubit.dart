import 'package:bloc/bloc.dart';
import 'package:meninki/features/product/models/product_parameters.dart';
import 'package:meta/meta.dart';

import '../../models/product_atribute.dart';

part 'compositions_creat_state.dart';

class CompositionsCreatCubit extends Cubit<CompositionsCreatState> {
  CompositionsCreatCubit() : super(CompositionsCreatInitial());

  Map<ProductParameter, List<ProductAttribute>> selectedParameters = {};

  selectParameter(ProductParameter param) {
    var exist = selectedParameters.containsKey(param);
    if (!exist) {
      selectedParameters[param] = [];
    } else {
      selectedParameters.remove(param);
    }
    emit.call(CompositionsCreating(selectedParameters));
  }

  selectAttribute(ProductParameter param, ProductAttribute attribute) {
    var list = selectedParameters[param] ?? [];
    var index = list.indexWhere((e) => e.id == attribute.id);
    if (index == -1) {
      list.add(attribute);
    } else {
      list.removeAt(index);
    }
    selectedParameters[param] = list;

    emit.call(CompositionsCreating(selectedParameters));
  }
}
