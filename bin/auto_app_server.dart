import 'dart:convert';
import 'package:auto_app_server/auth_user_from_sql.dart';
import 'package:auto_app_server/create_user_from_sql.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> arguments)async {
  Router router = Router();
  router.post('/reguser', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    createUserFromSQL(name: data['name'], phone: data['phone'], email: data['email'], password_hash: data['password_hash']);
    return Response.ok('ok');
  });
  router.post('/auth', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    print(data['email_or_phone']);
    print(data['password_hash']);
   var uid = await authUserFromSQL(email_or_phone: data['email_or_phone'], password_hash: data['password_hash']);
   print(uid);
    return Response.ok(jsonEncode(uid));
  });
  //щшщшош
  var server = await serve(router, '63.251.122.116', 2308);
}
