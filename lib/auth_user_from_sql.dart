import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mysql_client/mysql_client.dart';

Future<Map> authUserFromSQL({
  required email_or_phone,
  required password_hash,
  required MySQLConnection sql,
}) async {
  var key = utf8.encode('p@ssw0rd');
  var bytes = utf8.encode(password_hash);

  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  var digest = hmacSha256.convert(bytes);

  print("HMAC digest as bytes: ${digest.bytes}");
  print("HMAC digest as hex string: $digest");
  final email = await sql.execute(
    "SELECT * FROM users where email = '$email_or_phone'",
    {},
  );
  try {
    print(email.rows.first);
    print(email.rows.first.assoc()['password_hast']);
    if (password_hash == email.rows.first.assoc()['password_hast'] || digest ==  email.rows.first.assoc()['password_hast']) {
      final managerPhone = await sql.execute("select * from appconfins where conf_key = 'manager_phone'");
      return {
        'success': true,
        'uid':   int.parse(email.rows.first.assoc()['id'].toString()),
        'name': email.rows.first.assoc()['name'],
        'phone': email.rows.first.assoc()['phone'],
        'email':email.rows.first.assoc()['email'],
        'rules': email.rows.first.assoc()['rules'],
        'cid': email.rows.first.assoc()['cid'],
        'manager_phone': managerPhone.rows.first.assoc()['conf_value'],

      };
    } else {
      return {'success': false};
    }
  } catch (e) {
    try {
      print(e);
      final phone = await sql.execute(
        "SELECT * FROM users where phone = '$email_or_phone'",
        {},
      );
      print(phone.rows.first.assoc()['password_hast']);
      if (password_hash == phone.rows.first.assoc()['password_hast']) {
        final managerPhone = await sql.execute("select * from appconfins where conf_key = 'manager_phone'");
        return {
          'success': true,
          'uid':   int.parse(phone.rows.first.assoc()['id'].toString()),
          'name': phone.rows.first.assoc()['name'],
          'phone': phone.rows.first.assoc()['phone'],
          'email':phone.rows.first.assoc()['email'],
          'rules': phone.rows.first.assoc()['rules'],
          'cid': phone.rows.first.assoc()['cid'],
          'manager_phone': managerPhone.rows.first.assoc()['conf_value'],
        };
      } else {
        return {'success': false};
      }
    } catch (e) {
      print(e);
      return {'success': false};
    }
  }

  //   "insert into usertable (id, name, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, reviews, email_succes) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', '$servises', $rating, '$reviews', $email_succes);");
}
