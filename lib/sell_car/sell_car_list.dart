import 'package:mysql_client/mysql_client.dart';
Future<List> getSellCarList(MySQLConnection sql) async {
  List cars = [];
  final response = await sql.execute(
    "SELECT * FROM sell_requests",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();
    final car_bloc = await sql.execute(
      "SELECT * FROM usercars where id = ${data['cid']}",
      {},
    );
    cars.add(
      {
        'id': data['id'],
        'uid': data['uid'],
        'cid': data['cid'],
        'owner_name': data['owner_name'],
        'owner_email': data['owner_email'],
        'owner_phone': data['owner_phone'],
        'gcc': data['gcc'],
        'brand': car_bloc.rows.first.assoc()['brand'],
        'model': car_bloc.rows.first.assoc()['model'],
        'year': car_bloc.rows.first.assoc()['year'],
        'any_car_accidents': data['any_car_accidents'],
        'servise_history': data['servise_history'],
      },
    );
  }
  await sql.close();
  return cars;
}

