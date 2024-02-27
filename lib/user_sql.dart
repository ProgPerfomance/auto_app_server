import 'package:mysql_client/mysql_client.dart';

Future<Map> getUserInfo(String id, MySQLConnection sql) async {


  final response = await sql.execute(
    "SELECT * FROM users where id = $id",
    {},
  );
  var data = response.rows.first.assoc();
  Map user = {};
     user = await {
      'name': data['name'],
      'phone': data['phone'],
      'email': data['email'],
      'cid': data['cid'],
      'rules': data['rules'],
    };


  await sql.close();
  return user;
}