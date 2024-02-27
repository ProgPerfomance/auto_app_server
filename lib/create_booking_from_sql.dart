
import 'package:mysql_client/mysql_client.dart';

Future<int> createBookingFromSQL({
  required sql, required sid, required cid, required uid, required owner_name, required owner_email, required owner_phone, required pickup, required delivery, required timestamp, required date_time,
}) async {

  var resul = await sql.execute(
    "SELECT * FROM booking",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);

  var result = await sql.execute(
      "insert into booking (id, sid, cid, uid, owner_name,owner_email, owner_phone, pickup, delivery,timestamp, status, date_time) values (${id_int+1}, $sid, $cid, $uid, '$owner_name', '$owner_email', '$owner_phone', '$pickup', '$delivery', '$timestamp', 'Pending', '$date_time');");
  await sql.close();
  return id_int+1;
  //   "insert into usertable (id, name, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, reviews, email_succes) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', '$servises', $rating, '$reviews', $email_succes);");
}