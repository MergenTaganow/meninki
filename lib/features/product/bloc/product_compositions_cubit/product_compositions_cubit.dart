import 'package:bloc/bloc.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meta/meta.dart';

import '../../models/product_atribute.dart';
import '../../models/product_parameters.dart';
import '../../widgets/composition.dart';

part 'product_compositions_state.dart';

class ProductCompositionsCubit extends Cubit<ProductCompositionsState> {
  ProductCompositionsCubit() : super(ProductCompositionsLoading());

  Composition? selectedComposition;
  Map<ProductParameter, List<ProductAttribute>> allAttributes = {};
  Map<ProductParameter, ProductAttribute> selected = {};

  setProduct(Product product) {
    emit.call(ProductCompositionsLoading());
    allAttributes = _groupAttributesByParameter(product.compositions ?? []);
    selected =
        (product.compositions?.isNotEmpty ?? false)
            ? _selectedMapForComposition(product.compositions!.first)
            : {};
    selectedComposition = product.compositions?.first;
    emit(ProductCompositionsSuccess(allAttributes: allAttributes, selected: selected));
  }

  selectAttribute(Product product, ProductParameter parameter, ProductAttribute attribute) {
    final compositions = product.compositions ?? [];
    if (selected.isEmpty) {
      return;
    }

    final nextComposition = _resolveCompositionByAttribute(
      compositions: compositions,
      currentSelected: selected,
      tappedParameter: parameter,
      tappedAttribute: attribute,
    );

    if (nextComposition == null) return;

    selectedComposition = nextComposition;

    selected = _selectedMapForComposition(nextComposition);

    emit(ProductCompositionsSuccess(allAttributes: allAttributes, selected: selected));
  }

  Map<ProductParameter, List<ProductAttribute>> _groupAttributesByParameter(
    List<Composition> compositions,
  ) {
    final Map<ProductParameter, Set<ProductAttribute>> grouped = {};

    for (final composition in compositions) {
      final attributes = composition.attributes ?? [];

      for (final attribute in attributes) {
        final parameter = attribute.parameter;
        if (parameter == null) continue;

        grouped.putIfAbsent(parameter, () => <ProductAttribute>{});
        grouped[parameter]!.add(attribute);
      }
    }

    // Convert Set → List
    return grouped.map((key, value) => MapEntry(key, value.toList()));
  }

  Map<ProductParameter, ProductAttribute> _selectedMapForComposition(Composition composition) {
    final Map<ProductParameter, ProductAttribute> selected = {};

    final attributes = composition.attributes ?? [];

    for (final attribute in attributes) {
      final parameter = attribute.parameter;
      if (parameter == null) continue;

      // one attribute per parameter → last wins (or first, see note)
      selected[parameter] = attribute;
    }

    return selected;
  }

  Composition? _resolveCompositionByAttribute({
    required List<Composition> compositions,
    required Map<ProductParameter, ProductAttribute> currentSelected,
    required ProductParameter tappedParameter,
    required ProductAttribute tappedAttribute,
  }) {
    // 1️⃣ Build desired selection (keep others, replace tapped)
    final desired = Map<ProductParameter, ProductAttribute>.from(currentSelected);
    desired[tappedParameter] = tappedAttribute;

    // 2️⃣ Try to find composition that matches ALL desired selections
    for (final composition in compositions) {
      final attrs = composition.attributes ?? [];

      bool matches = true;

      for (final entry in desired.entries) {
        final hasAttribute = attrs.any((a) => a.parameter == entry.key && a.id == entry.value.id);

        if (!hasAttribute) {
          matches = false;
          break;
        }
      }

      if (matches) {
        return composition;
      }
    }

    // 3️⃣ Fallback: first composition that contains tapped attribute
    for (final composition in compositions) {
      final attrs = composition.attributes ?? [];

      final hasTapped = attrs.any(
        (a) => a.parameter == tappedParameter && a.id == tappedAttribute.id,
      );

      if (hasTapped) {
        return composition;
      }
    }

    // 4️⃣ Nothing found (edge case)
    return null;
  }
}
