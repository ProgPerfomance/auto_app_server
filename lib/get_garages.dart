import 'package:mysql_client/mysql_client.dart';
Future<List> getUserCarList(String id, MySQLConnection sql) async {
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
        'phone': data['year'],
        'email': data['model'],
      },
    );
  }
  return garages;
}