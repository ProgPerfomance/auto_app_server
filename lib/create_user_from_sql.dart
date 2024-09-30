

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mysql_client/mysql_client.dart';

Future<Map<String, dynamic>> createUserFromSQL({
  required MySQLConnection sql,
  required String name,
  required String phone,
  required String email,
  required String password_hash,
  required rules,
}) async {
  var key = utf8.encode('p@ssw0rd');
  var bytes = utf8.encode(password_hash);

  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  var digest = hmacSha256.convert(bytes);

  print("HMAC digest as bytes: ${digest.bytes}");
  print("HMAC digest as hex string: $digest");
  var resul = await sql.execute(
    "SELECT * FROM users",
    <String, dynamic>{}, // Используйте Map<String, dynamic> для параметров запроса
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);
  try{
 final mail =   await sql.execute("select * from users where email = '$email'");
 mail.rows.first.assoc()['name'];
    return {
      'success': false,
    };
  }
  catch(e) {
    await sql.execute(
      "insert into users (id, name, phone, email, password_hast, rules) values (${id_int +
          1}, '$name', '$phone', '$email', '$digest', $rules);",
    );
    final managerPhone = await sql.execute("select * from appconfins where conf_key = 'manager_phone'");
    return {
      'success': true,
      'uid': id_int + 1,
      'name': name,
      'email': email,
      'phone': phone,
      'rules': rules,
      'manager_phone': managerPhone.rows.first.assoc()['value'],
    };
  }
}