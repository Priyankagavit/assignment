
import 'package:assignment_test/events/product_event.dart';
import 'package:assignment_test/model/product.dart';

class AddProduct extends ProductEvent {
  Product productFood;

  AddProduct(Product product){
    productFood = product;
  }
}