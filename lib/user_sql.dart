import 'package:mysql_client/mysql_client.dart';

Future<Map> getUserInfo(var id, MySQLConnection sql) async {


  final response = await sql.execute(
    "SELECT * FROM users where id = $id",
    {},
  );
  var data = response.rows.first.assoc();
  final managerPhone = await sql.execute("select * from appconfins where conf_key = 'manager_phone'");
  Map user = {};
     user = await {
      'name': data['name'],
      'phone': data['phone'],
      'email': data['email'],
      'cid': data['cid'],
      'rules': data['rules'],
       'manager_phone': managerPhone.rows.first.assoc()['conf_value'],
    };
  return user;
}

Future<void> updateUserToken(uid, token, MySQLConnection sql) async {
  await sql.execute("update users set token = '$token' where id =$uid");
}