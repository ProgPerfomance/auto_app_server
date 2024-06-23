import 'package:auto_app_server/mail_service.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:uuid/uuid.dart';

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

Future<bool> forgotPassword(email, MySQLConnection sql) async {
  try {
    final response = await sql.execute(
        "select * from users where email = '$email'");
    final newPassword = Uuid().v1();
    sendMail(newPassword);
    await sql.execute("update users set password_hast = '$newPassword' where email = '$email'");
    return true;
  }catch(e) {
    return false;
  }
}