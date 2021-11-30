

import 'package:assignment_test/db/database_provider.dart';

class Product {
  int id;
  String name;
  String launchedAt;
  String launchSite;
  String popularity;

  Product({this.id, this.name, this.launchedAt, this.launchSite,this.popularity});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME: name,
      DatabaseProvider.COLUMN_LAUNCHEDAT: launchedAt,
      DatabaseProvider.COLUMN_LAUNCHSITE: launchSite,
      DatabaseProvider.COLUMN_POPULARITY: popularity,
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Product.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    name = map[DatabaseProvider.COLUMN_NAME];
    launchedAt = map[DatabaseProvider.COLUMN_LAUNCHEDAT];
    launchSite = map[DatabaseProvider.COLUMN_LAUNCHSITE];
    popularity = map[DatabaseProvider.COLUMN_POPULARITY];
  }
}