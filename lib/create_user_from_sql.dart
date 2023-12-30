import 'package:mysql_client/mysql_client.dart';


Future<int> createUserFromSQL({
  required name,
  required phone,
  required email,
  required password_hash,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'auto');
  await sql.connect();
  print(sql.connected);
  // make query (notice third parameter, iterable=true)
  var resul = await sql.execute(
    "SELECT * FROM users",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);

  var result = await sql.execute(
      "insert into users (id, name, phone, email, password_hast, rules) values (${id_int + 1}, '$name', '$phone', '$email', '$password_hash', 'user');");
  await sql.close();
  return id_int+1;
  //   "insert into usertable (id, name, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, reviews, email_succes) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', '$servises', $rating, '$reviews', $email_succes);");
}
