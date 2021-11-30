import 'package:assignment_test/bloc/product_bloc.dart';
import 'package:assignment_test/db/database_provider.dart';
import 'package:assignment_test/events/delete_product.dart';
import 'package:assignment_test/events/set_product.dart';
import 'package:assignment_test/model/product.dart';
import 'package:assignment_test/ui/product_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getProducts().then(
      (productList) {
        BlocProvider.of<ProductBloc>(context).add(SetProducts(productList));
      },
    );
  }

  showProductDialog(BuildContext context, Product product, int index) {
    showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text('Do you really want to delete ?'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () =>
                         DatabaseProvider.db.delete(product.id).then((_) {
              BlocProvider.of<ProductBloc>(context).add(
                DeleteProduct(index),
              );
              Navigator.pop(context);
            }),
                    child: Text('OK'),
                  ),
                  FlatButton(
                    onPressed: () =>  Navigator.pop(context),
                    child: Text('CANCEL'),
                  ),
                ],
              ),
            );
  }

 
  @override
  Widget build(BuildContext context) {
    print("Building entire product list scaffold");
    return Scaffold(
      appBar: AppBar(
        title: Text("ProductList"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey,
        child: BlocConsumer<ProductBloc, List<Product>>(
          builder: (context, productList) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                print("productList: $productList");

                Product product = productList[index];
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(product.name, style: TextStyle(fontSize: 26)),
                    subtitle: Text(
                      "Launch Site: ${product.launchSite}\nLaunchAt: ${product.launchedAt}\nPopularity: ${product.popularity}",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Wrap(
                      spacing: 2, // space between two icons
                      children: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductForm(
                                  product: product, productIndex: index,isFrom: true,),
                            ),
                          ),
                          child: Icon(Icons.update),
                        ), // icon-2
                        FlatButton(
                          onPressed: () =>
                              showProductDialog(context, product, index),
                          child: Icon(Icons.delete),
                        ), // icon-1
                      ],
                    ),
                  ),
                );
              },
              itemCount: productList.length,
            );
          },
          listener: (BuildContext context, productList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => ProductForm(isFrom: false,)),
        ),
      ),
    );
  }
}
