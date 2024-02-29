import 'package:mysql_client/mysql_client.dart';

Future<Map<String, dynamic>> createUserFromSQL({
  required MySQLConnection sql,
  required String name,
  required String phone,
  required String email,
  required String password_hash,
}) async {
  var resul = await sql.execute(
    "SELECT * FROM users",
    <String, dynamic>{}, // Используйте Map<String, dynamic> для параметров запроса
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);

  await sql.execute(
      "insert into users (id, name, phone, email, password_hast, rules) values (${id_int+1}, '$name', '$phone', '$email', '$password_hash', 0);",
      // Передайте параметры запроса в виде Map<String, dynamic>

  );
  return {
    'uid': id_int + 1,
    'name': name,
    'email': email,
    'phone': phone,
    'rules': 0,
  };
}