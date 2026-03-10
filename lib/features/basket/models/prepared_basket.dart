import 'package:meninki/features/address/models/address.dart';
import 'package:meninki/features/basket/models/basket_product.dart';
import 'package:meninki/features/orders/model/tax.dart';

class PreparedBasket {
  List<BasketProduct>? baskets;
  Address? address;
  List<Tax>? basket_taxes;

  PreparedBasket({this.baskets, this.address, this.basket_taxes});

  factory PreparedBasket.fromJson(Map<String, dynamic> json) {
    return PreparedBasket(
      baskets:
          json["baskets"] != null
              ? (json["baskets"] as List).map((e) => BasketProduct.fromJson(e)).toList()
              : null,
      address: json["address"] != null ? Address.fromJson(json["address"]) : null,
      basket_taxes:
          json["basket_taxes"] != null
              ? (json["basket_taxes"] as List).map((e) => Tax.fromJson(e)).toList()
              : null,
    );
  }

  num summary() {
    num sum = 0;
    for (var i in baskets ?? <BasketProduct>[]) {
      sum += i.composition?.product?.discount ?? i.composition?.product?.price ?? 0;
    }
    return sum;
  }
}
