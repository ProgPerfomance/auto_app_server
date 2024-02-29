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
    <String, dynamic>{}, // Укажите, что это Map<String, dynamic>, если это необходимо
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);

  await sql.execute(
    // Убедитесь, что здесь нет опечаток, исправлено на 'password_hash'
      "insert into users (id, name, phone, email, password_hash, rules) values (?, ?, ?, ?, ?, ?);",
      [id_int + 1, name, phone, email, password_hash, 0] as Map<String, dynamic>? // Используйте параметризированные запросы для безопасности
  );
  return {
    'uid': id_int + 1,
    'name': name,
    'email': email,
    'phone': phone,
    'rules': 0,
  };
}