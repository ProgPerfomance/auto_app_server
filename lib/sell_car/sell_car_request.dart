import 'package:mysql_client/mysql_client.dart';


Future<void> sellCarRequest(
{
 required var uid,
required  var cid,
required  var owner_name,
required  var owner_email,
required  var owner_phone,
 required var any_car_accidents,
required  var gcc,
 required var servise_history,
  required MySQLConnection sql,
}
) async {

  // make query (notice third parameter, iterable=true)
  var resul = await sql.execute(
    "SELECT * FROM sell_requests",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);

  var result = await sql.execute(
      "insert into sell_requests (id, uid, cid, owner_name, owner_email, owner_phone, any_car_accidents, gcc, servise_history) values (${id_int+1}, $uid, $cid, '$owner_name', '$owner_email', '$owner_phone', $any_car_accidents, $gcc, $servise_history);");
  //   "insert into usertable (id, name, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, reviews, email_succes) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', '$servises', $rating, '$reviews', $email_succes);");
}
