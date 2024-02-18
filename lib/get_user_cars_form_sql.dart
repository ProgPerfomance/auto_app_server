import 'dart:io';

import 'package:mysql_client/mysql_client.dart';
Future<List> getUserCarList(String id) async {
  List cars = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp');
  await sql.connect();
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
  await sql.close();
  return cars;
}


void deleteUserCarFromSql({
  required id,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp');
  await sql.connect();
  print(sql.connected);
  var result = await sql.execute(
      "delete from usercars where id =$id;");
  await sql.close();
}
