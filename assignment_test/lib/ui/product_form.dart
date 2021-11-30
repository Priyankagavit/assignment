import 'package:assignment_test/bloc/product_bloc.dart';
import 'package:assignment_test/db/database_provider.dart';
import 'package:assignment_test/events/add_product.dart';
import 'package:assignment_test/events/update_product.dart';
import 'package:assignment_test/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class ProductForm extends StatefulWidget {
  final Product product;
  final int productIndex;
  bool isFrom = false;

  ProductForm({this.product, this.productIndex, this.isFrom});

  @override
  State<StatefulWidget> createState() {
    return ProductFormState();
  }
}

class ProductFormState extends State<ProductForm> {
  String _name;
  String _launchSite;
  String _launchedAt;
  String _popularity;
  bool isFrom;
  String serviceDate = "";
  String service_Date = "";
  TextEditingController sdate = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 15,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildLaunchAt() {
    return TextField(
      readOnly: true,
      style: TextStyle(fontSize: 28),
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 28),
        labelText: 'Service Date',
        suffixIcon: Icon(
          Icons.calendar_today,
          size: 26,
        ),
      ),
      controller: sdate,
      onTap: () async {
        DateTime date = DateTime(2000);
        FocusScope.of(context).requestFocus(FocusNode());
        date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2030));

        sdate.text = getFormattedDateMMMddyyyy(date);
        _launchedAt = getFormattedDateMMMddyyyy(date);
      },
    );
  }

  String getFormattedDateMMMddyyyy(DateTime date) {
    var strDate = formatDate(date, [M, ' ', dd, ',', ' ', yyyy]);
    print("test date1 ");
    print(strDate);
    return strDate;
  }

  Widget _buildLaunchSite() {
    return TextFormField(
      initialValue: _launchSite,
      decoration: InputDecoration(labelText: 'LaunchSite'),
      maxLength: 15,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'LaunchSite is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _launchSite = value;
      },
    );
  }

  Widget _buildPopularity() {
    return TextFormField(
      initialValue: _popularity,
      decoration: InputDecoration(labelText: 'Popularity'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        int popularity = int.tryParse(value);

        if (popularity == null || popularity <= 0) {
          return 'Popularity must be greater than 0';
        }

        return null;
      },
      onSaved: (String value) {
        _popularity = value;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    service_Date = new DateFormat.yMMMd().format(new DateTime.now());
    _launchedAt = getFormattedDateMMMddyyyy(DateTime.now());
    sdate.text = service_Date;
    if (widget.product != null) {
      _name = widget.product.name;
      _launchSite = widget.product.launchSite;
      _launchedAt = widget.product.launchedAt;
      _popularity = widget.product.popularity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: widget.isFrom == true
              ? Text("Edit Product")
              : Text("Add Product")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _buildLaunchAt(),
              SizedBox(height: 16),
              _buildLaunchSite(),
              SizedBox(height: 20),
              _buildPopularity(),
              SizedBox(height: 20),
              widget.product == null
                  ? RaisedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        _formKey.currentState.save();

                        Product product = Product(
                          name: _name,
                          launchSite: _launchSite,
                          launchedAt: _launchedAt,
                          popularity: _popularity,
                        );

                        DatabaseProvider.db.insert(product).then(
                              (storedFood) =>
                                  BlocProvider.of<ProductBloc>(context).add(
                                AddProduct(storedFood),
                              ),
                            );

                        Navigator.pop(context);
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Update",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              print("form");
                              return;
                            }

                            _formKey.currentState.save();

                            Product product = Product(
                              name: _name,
                              launchSite: _launchSite,
                              launchedAt: _launchedAt,
                              popularity: _popularity,
                            );

                            DatabaseProvider.db.update(widget.product).then(
                                  (storedFood) =>
                                      BlocProvider.of<ProductBloc>(context).add(
                                    UpdateProduct(widget.productIndex, product),
                                  ),
                                );

                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
