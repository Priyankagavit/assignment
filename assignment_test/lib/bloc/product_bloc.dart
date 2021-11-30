
import 'package:assignment_test/events/add_product.dart';
import 'package:assignment_test/events/delete_product.dart';
import 'package:assignment_test/events/product_event.dart';
import 'package:assignment_test/events/set_product.dart';
import 'package:assignment_test/events/update_product.dart';
import 'package:assignment_test/model/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, List<Product>> {
  

  @override
  List<Product> get initialState => List<Product>();

  @override
  Stream<List<Product>> mapEventToState(ProductEvent event) async* {
    if (event is SetProducts) {
      yield event.productList;
    } else if (event is AddProduct) {
      List<Product> newState = List.from(state);
      if (event.productFood != null) {
        newState.add(event.productFood);
      }
      yield newState;
    } else if (event is DeleteProduct) {
      List<Product> newState = List.from(state);
      newState.removeAt(event.productIndex);
      yield newState;
    } else if (event is UpdateProduct) {
      List<Product> newState = List.from(state);
      newState[event.productIndex] = event.newProduct;
      yield newState;
    }
  }
}