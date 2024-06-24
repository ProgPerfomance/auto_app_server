import 'package:auto_app_server/push_service.dart';
import 'package:mysql_client/mysql_client.dart';

Future<int> createBookingFromSQL({
  required MySQLConnection sql,
  required String sid,
  required String cid,
  required String uid,
  required String? owner_name,
  required String owner_email,
  required String? owner_phone,
  required String? pickup,
  required String? delivery,
  required String? timestamp,
  required String? date_time,
  required String description,
}) async {
  var resul = await sql.execute(
    "SELECT * FROM booking",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  await sql.execute(
      "insert into booking (id, sid, cid, uid, owner_name,owner_email, owner_phone, pickup, delivery,timestamp, status, date_time,description) values (${id_int + 1}, $sid, $cid, $uid, '$owner_name', '$owner_email', '$owner_phone', '$pickup', '$delivery', '$timestamp', 'Pending', '$date_time', '$description');");
  final tokenRow = await sql.execute('select * from users where id = 0');
  localPush(tokenRow.rows.first.assoc()['token'], 'New booking!', '$owner_name, Problem: $description');
  return id_int + 1;
  //   "insert into usertable (id, name, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, reviews, email_succes) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', '$servises', $rating, '$reviews', $email_succes);");
}

Future<int> createBookingSpecialOffer({
  required MySQLConnection sql,
  required String sid,
  required String cid,
  required String uid,
  required String? owner_name,
  required String owner_email,
  required String? owner_phone,
  required String? pickup,
  required String? delivery,
  required String? timestamp,
  required String? date_time,
  required String garage,
  required String description,
}) async {
  var resul = await sql.execute(
    "SELECT * FROM booking",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  await sql.execute(
      "insert into booking (id, sid, cid, uid, owner_name,owner_email, owner_phone, pickup, delivery,timestamp, status, date_time, garage, description) values (${id_int + 1}, $sid, $cid, $uid, '$owner_name', '$owner_email', '$owner_phone', '$pickup', '$delivery', '$timestamp', 'Pending', '$date_time', $garage, '$description');");
  final tokenRow = await sql.execute('select * from users where id = $garage');
  localPush(tokenRow.rows.first.assoc()['token'], 'New sell car request!', '$owner_name, Problem: $description');
  return id_int + 1;
  //   "insert into usertable (id, name, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, reviews, email_succes) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', '$servises', $rating, '$reviews', $email_succes);");
}
