import 'dart:io';

import 'package:mysql_client/mysql_client.dart';

Future<List> getCarWishList(String uid,  MySQLConnection sql) async {
  List cars = [];
  final response = await sql.execute(
    "SELECT * FROM carlist",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();
    var images = [];
    var like;
    var like_id;
    Directory directory = Directory('images/${data['id']}');
    await for(var entity in directory.list()) {
      File file = entity as File;
      images.add(entity.readAsBytesSync());
    }
    final likeRaw = await sql.execute(
      "SELECT * FROM likes where uid = $uid and pid = ${data['id']}",
      {},
    );
    try {
      like_id =likeRaw.rows.first.assoc()['id'];
      like = true;
    } catch(_) {
      like_id = null;
      like = false;
    }
 like == true ?  cars.add(
      {
        'like_id': like_id,
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
        'images': images[0],
      },
    ): null;
  }
  return cars;
}