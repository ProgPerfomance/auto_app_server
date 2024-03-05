import 'package:mysql_client/mysql_client.dart';
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
    "update orders set name='$name', email='$email', phone='$phone',password_hast='$password' WHERE id = $id",
  );
}