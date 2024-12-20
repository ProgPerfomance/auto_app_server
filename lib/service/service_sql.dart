import 'dart:convert';

import 'package:mysql_client/mysql_client.dart';
import 'package:auto_app_server/push_service.dart';
Future<Map> getServiceInfo(String id, MySQLConnection sql) async {
  final response = await sql.execute(
    "SELECT * FROM servises where id = $id",
    {},
  );
  final included = await sql.execute(
    "SELECT * FROM service_blocs where sid = $id and included = 1",
    {},
  );
  final notIncluded = await sql.execute(
    "SELECT * FROM service_blocs where sid = $id and included = 0",
    {},
  );
  List includedList = [];
  List notIncludedList = [];
  for (var inc in included.rows) {
    includedList.add({'title': inc.assoc()['title'], 'id': inc.assoc()['id']});
  }
  for (var inc in notIncluded.rows) {
    notIncludedList
        .add({'title': inc.assoc()['title'], 'id': inc.assoc()['id']});
  }
  final dataService = response.rows.first.assoc();
  return {
    'name': dataService['name'],
    'price': dataService['price'],
    'description': dataService['description'],
    'low_price': dataService['low_price'],
    'included': includedList,
    'not_included': notIncludedList,
  };
}

Future<void> addServiceBlock(MySQLConnection sql,
    {sid, title, included}) async {
  var resul = await sql.execute(
    "SELECT * FROM service_blocs",
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  await sql.execute(
      "insert into service_blocs (id, sid, title, included) values (${id_int + 1}, $sid, '$title', $included)");
}

Future<void> deleteServiceBlock(MySQLConnection sql, {id}) async {
  await sql.execute("delete from service_blocs where id =$id;");
}

Future<void> updateServiceBlock(MySQLConnection sql, {id, title}) async {
  await sql.execute("update service_blocs set title ='$title' where id =$id;");
}

Future<void> createOffer(MySQLConnection sql,
    {required name,
    required price,
    required low_price,
    required description,
    required garage}) async {
  var resul = await sql.execute(
    "SELECT * FROM servises",
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  await sql.execute(
      "insert into servises (id, name, price, low_price, description, special_offer, garage) values (${id_int + 1},'$name', $price, $low_price, '$description', 1, $garage)");
  globalPush('New special offer!', '$name. Old price: $low_price, new price: $price');
}

Future<List> getMyOffers(MySQLConnection sql, {required garage}) async {
  List offers = [];

  final response = await sql.execute(
    "SELECT * FROM servises where garage =$garage and  special_offer = '1' and visible = 1",
    {},
  );

  for (final row in response.rows) {
    final data = row.assoc();
    offers.add(
      {
        'id': data['id'],
        'name': data['name'],
        'price': data['price'],
        'low_price': data['low_price'],
        'garage': data['garage'],
        'description': data['description'],
      },
    );
  }
  return List.from(offers.reversed);
}

Future<List> getLastOffers(MySQLConnection sql) async {
  List offers = [];

  final response = await sql.execute(
    "SELECT * FROM servises where special_offer = '1' and visible = 1",
    {},
  );

  for (final row in response.rows) {
    final data = row.assoc();
    offers.add(
      {
        'id': data['id'],
        'name': data['name'],
        'price': data['price'],
        'low_price': data['low_price'],
        'garage': data['garage'],
        'description': data['description'],
      },
    );
  }
  return List.from(offers.reversed);
}

Future<void> updateServiceInfo(MySQLConnection sql,
    {required id,required price,required priceMin,required description}) async {
  await sql.execute(
      "update servises set price=$price, low_price=$priceMin, description='$description' where id=$id");
}


Future<void> deleteSpeccialOffer(MySQLConnection sql, id) async  {
 await sql.execute('update servises set visible = 0 where id = $id');
}