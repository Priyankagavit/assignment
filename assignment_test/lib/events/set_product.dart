

import 'package:assignment_test/events/product_event.dart';
import 'package:assignment_test/model/product.dart';

class SetProducts extends ProductEvent {
  List<Product> productList;

  SetProducts(List<Product> products) {
    productList = products;
  }
}