import 'dart:io';

import 'package:mysql_client/mysql_client.dart';
 Future<List> getCarList(String id,  MySQLConnection sql) async {
  List cars = [];
  final response = await sql.execute(
    "SELECT * FROM carlist where status = 1",
    {},
  );

   for (final row in response.rows) {
    var data = row.assoc();
    Directory directory = Directory('images/${data['ccid']}');
    var like;
    var like_id;
    final likeRaw = await sql.execute(
      "SELECT * FROM likes where uid = $id and pid = ${data['id']}",
      {},
    );
    try {
      like_id =likeRaw.rows.first.assoc()['id'];
      like = true;
    } catch(_) {
      like_id = null;
      like = false;
    }
    cars.add(
      {
        'like_id': like_id,
        'cash': data['cash'],
        'liked': like.toString(),
        'id': data['id'],
        'name': data['name'],
        'brand': data['brand'],
        'model': data['model'],
        'price_usd': data['price_usd'],
        'price_aed': data['price_aed'],
        'color': data['color'],
        'killometers': data['killometers'],
        'regional_specs': data['regional_specs'],
        'transmission': data['transmission'],
        'steering_whell': data['steering_whell'],
        'motor_trim': data['motor_trim'],
        'body': data['body'],
        'state': data['state'],
        'guarantee': data['guarantee'],
        'service_contact': data['service_contact'],
        'ccid': data['ccid'],
        'year': data['year'],
        'description': data['description'],
        'images': directory.listSync().length,
      },
    );
  }
  return List.from(cars.reversed);
}

Future<Map> getCarInfo(String id, String uid, MySQLConnection sql) async {
  Map car = {};
  final response = await sql.execute(
    "SELECT * FROM carlist where id=$id",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();
    Directory directory = Directory('images/${data['ccid']}');
print( directory.listSync().length);
    var like;
    var like_id;
    final likeRaw = await sql.execute(
      "SELECT * FROM likes where uid = $uid and pid = $id",
      {},
    );
    try {
      like_id =likeRaw.rows.first.assoc()['id'];
      like = true;
    } catch(_) {
      like_id = null;
      like = false;
    }
    car =
      {
        'id': data['id'],
        'cash': data['cash'],
        'name': data['name'],
        'brand': data['brand'],
        'model': data['model'],
        'price_usd': data['price_usd'],
        'price_aed': data['price_aed'],
        'color': data['color'],
        'killometers': data['killometers'],
        'regional_specs': data['regional_specs'],
        'transmission': data['transmission'],
        'steering_whell': data['steering_whell'],
        'motor_trim': data['motor_trim'],
        'body': data['body'],
        'state': data['state'],
        'guarantee': data['guarantee'],
        'service_contact': data['service_contact'],
        'ccid': data['ccid'],
        'year': data['year'],
        'images': directory.listSync().length,
        'like_id': like_id,
        'liked': like.toString(),
        'description': data['description'],
      };

  }
  print('req');
  return car;
}



Future<void> deleteCar(id, MySQLConnection sql)async {
   sql.execute('update carlist set status=0 where id=$id');
}