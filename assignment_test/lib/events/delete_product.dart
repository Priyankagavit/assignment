
import 'package:assignment_test/events/product_event.dart';

class DeleteProduct extends ProductEvent {
  int productIndex;

  DeleteProduct(int index) {
    productIndex = index;
  }
}