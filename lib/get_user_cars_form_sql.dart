import 'dart:io';

import 'package:mysql_client/mysql_client.dart';
Future<List> getUserCarList(String id, MySQLConnection sql) async {
  List cars = [];
  final response = await sql.execute(
    "SELECT * FROM usercars where uid = $id",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();

    cars.add(
      {
        'id': data['id'],
        'name': data['name'],
        'year': data['year'],
        'model': data['model'],
        'brand': data['brand'],
        'car_reg': data['car_reg'],
      },
    );
  }
  return cars;
}


void deleteUserCarFromSql({
  required id,
  required MySQLConnection sql,
}) async {

  var result = await sql.execute(
      "delete from usercars where id =$id;");
}
