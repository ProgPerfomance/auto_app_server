import 'package:mysql_client/mysql_client.dart';

import '../push_service.dart';
Future<List> getGaragesList(MySQLConnection sql) async {
  List garages = [];
  final response = await sql.execute(
    "SELECT * FROM users where rules = 1",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();

    garages.add(
      {
        'id': data['id'],
        'name': data['name'],
        'phone': data['phone'],
        'email': data['email'],
        'password': data['password_hast'],
      },
    );
  }
  return garages;
}

Future<void> updateGarage(MySQLConnection sql, {
  required name,
  required password,
  required phone,
  required email,
  required id,
}) async {
await sql.execute(
    "update users set name='$name', email='$email', phone='$phone',password_hast='$password' WHERE id = $id",
  );
}

Future<void> deleteGarage(MySQLConnection sql, {required id}) async {
  await sql.execute(
    "delete from users where id =$id;",
  );
}

Future<void> setGarage(MySQLConnection sql, {required id, required garage}) async {
  await sql.execute(
    "update booking set garage = $garage where id = $id",
  );
  final tokenRow = await sql.execute('select * from users where id = $garage');
  localPush(tokenRow.rows.first.assoc()['token'], 'New booking', 'Check your booking!');
}