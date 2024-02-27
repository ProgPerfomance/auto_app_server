import 'package:mysql_client/mysql_client.dart';


Future<int> createUserCarFromSQL({
  required sql,
 required uid,
  required name,
  required brand,
  required model,
  required year,
  required car_reg,
}) async {
  var resul = await sql.execute(
    "SELECT * FROM usercars",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);

  var result = await sql.execute(
      "insert into usercars (id, uid, name, brand, model, year, car_reg) values (${id_int + 1}, $uid, '$name', '$brand', '$model', $year, '$car_reg');");
  await sql.close();
  return id_int+1;
  //   "insert into usertable (id, name, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, reviews, email_succes) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', '$servises', $rating, '$reviews', $email_succes);");
}

Future<void> updateUserCarFromSQL({
  required id,
  required name,
  required brand,
  required model,
  required year,
  required car_reg,
  required  MySQLConnection sql,
}) async {
  var resul = await sql.execute(
    "SELECT * FROM usercars where id= $id",
    {},
  );
  var result = await sql.execute(
      "update usercars set name='$name', brand='$brand', model='$model', year=$year, car_reg='$car_reg' where id =$id;");
  await sql.close();
  //   "insert into usertable (id, name, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, reviews, email_succes) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', '$servises', $rating, '$reviews', $email_succes);");
}
