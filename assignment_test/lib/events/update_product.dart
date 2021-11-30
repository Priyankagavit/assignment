
import 'package:assignment_test/events/product_event.dart';
import 'package:assignment_test/model/product.dart';

class UpdateProduct extends ProductEvent {
  Product newProduct;
  int productIndex;

  UpdateProduct(int index, Product product) {
    newProduct = product;
    productIndex = index;
  }
}