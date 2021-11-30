
import 'package:assignment_test/ui/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/product_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (context) => ProductBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Assignment',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: ProductList(),
      ),
    );
  }
}