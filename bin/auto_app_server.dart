import 'dart:convert';
import 'dart:io';
import 'package:auto_app_server/auth_user_from_sql.dart';
import 'package:auto_app_server/create_adverb_from_sql.dart';
import 'package:auto_app_server/create_booking_from_sql.dart';
import 'package:auto_app_server/create_user_car_from_sql.dart';
import 'package:auto_app_server/create_user_from_sql.dart';
import 'package:auto_app_server/get_booking_list_from_sql.dart';
import 'package:auto_app_server/get_car_list.dart';
import 'package:auto_app_server/get_user_cars_form_sql.dart';
import 'package:auto_app_server/like_car_from_sql.dart';
import 'package:auto_app_server/sell_car/sell_car_list.dart';
import 'package:auto_app_server/sell_car/sell_car_request.dart';
import 'package:auto_app_server/user_sql.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

void main(List<String> arguments) async {
  Router router = Router();
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp');
  await sql.connect();
  router.post('/reguser', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    createUserFromSQL(
        sql: sql,
        name: data['name'],
        phone: data['phone'],
        email: data['email'],
        password_hash: data['password_hash']);
    return Response.ok('ok');
  });
  router.post('/getcarinfo', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var resp = await getCarInfo(data['id'], sql);
    return Response.ok(jsonEncode(resp));
  });
  router.post('/getsellrequests', (Request request) async {
    var resp = await getSellCarList(sql); //
    return Response.ok(jsonEncode(resp));
  });
  router.post('/auth', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    print(data['email_or_phone']);
    print(data['password_hash']);
    var uid = await authUserFromSQL(
        sql: sql,
        email_or_phone: data['email_or_phone'],
        password_hash: data['password_hash']);
    print(uid);
    return Response.ok(jsonEncode(uid));
  });
  router.post('/createcar', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);

    createAdverbFromSql(
        sql: sql,
        year: 'year',
        name: data['name'],
        brand: data['brand'],
        model: data['model'],
        price_usd: data['price_usd'],
        price_aed: data['price_aed'],
        color: data['color'],
        killometers: data['killometers'],
        regional_specs: data['regional_specs'],
        transmission: data['transmission'],
        steering_whell: data['steering_whell'],
        motor_trim: data['motor_trim'],
        body: data['body'],
        state: data['state'],
        guarantee: data['guarantee'],
        service_contact: data['service_contact']);

    return Response.ok('created');
  });
  router.post('/getcars', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    List rep = await getCarList(data['id'], sql);
    return Response.ok(jsonEncode(rep));
  });
  router.post('/sellcarrequest', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await sellCarRequest(
        sql: sql,
        any_car_accidents: data['any_car_accidents'],
        uid: data['uid'],
        cid: data['cid'],
        gcc: data['gcc'],
        owner_email: data['owner_email'],
        owner_name: data['owner_name'],
        owner_phone: data['owner_phone'],
        servise_history: data['servise_history']);
    return Response.ok('ok');
  });
  router.post('/likecar', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    likeCarFromSql(uid: data['uid'], cid: data['cid'], sql: sql);
    return Response.ok('');
  });
  router.post('/dislikecar', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    dislikeCarFromSql(id: data['id'], sql: sql);
    return Response.ok('');
  });
  router.post('/createusercar', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    createUserCarFromSQL(
        sql: sql,
        uid: data['uid'],
        name: data['name'],
        brand: data['brand'],
        model: data['model'],
        year: data['year'],
        car_reg: data['car_reg']);
    return Response.ok('');
  });
  router.post('/getusercars', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var rep = await getUserCarList(data['uid'], sql);
    return Response.ok(jsonEncode(rep));
  });
  router.post('/getuserbooking', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var rep = await getUserBookingList(data['uid'], sql);
    return Response.ok(jsonEncode(rep));
  });
  router.post('/getmasterbooking', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var rep = await getUserBookingListMaster(data['cid'], sql);
    return Response.ok(jsonEncode(rep));
  });
  router.post('/getnewmasterbooking', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var rep = await getNewBookingListMaster(data['cid'], sql);
    return Response.ok(jsonEncode(rep));
  });
  router.post('/getuserinfo', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var rep = await getUserInfo(data['uid'], sql);
    return Response.ok(jsonEncode(rep));
  });
  router.post('/updatebooking', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    updateBookingStatus(data['id'], data['status'], sql);
    return Response.ok('updated');
  });

  router.post('/updateusercars', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    updateUserCarFromSQL(
        sql: sql,
        id: data['id'],
        name: data['name'],
        brand: data['brand'],
        model: data['model'],
        year: data['year'],
        car_reg: data['car_reg']);
    return Response.ok('');
  });
  router.post('/createbooking', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    createBookingFromSQL(
        sql: sql,
        sid: data['sid'],
        cid: data['cid'],
        uid: data['uid'],
        owner_name: data['owner_name'],
        owner_email: data['owner_email'],
        owner_phone: data['owner_phone'],
        pickup: data['pickup'],
        delivery: data['delivery'],
        timestamp: data['timestamp'],
        date_time: data['date_time']);
    return Response.ok('');
  });
  router.post('/deleteusercar', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    deleteUserCarFromSql(id: data['id'], sql: sql);
    return Response.ok('');
  });
  Map<String, List<WebSocket>> chatConnections = {};
  router.mount('/ws/', webSocketHandler((webSocket) async {
    // Чтение сообщений от клиентов и отправка сообщений всем подключенным клиентам
    await for (var message in webSocket) {
      // Преобразование сообщения в формат JSON
      var data = json.decode(message);

      // Отправка сообщения всем клиентам в том же чате
      // (в данном примере предполагается, что data содержит идентификатор чата)
      await sendMessageToChatMembers(data['chatId'], message);
    }
  }));


  var server = await HttpServer.bind('63.251.122.116', 2308);
  print('Serving at http://${server.address.host}:${server.port}');
  await server.forEach((httpRequest) async {
    // Создание объекта Request из HttpRequest
    var request = Request(httpRequest.method, Uri.parse(httpRequest.uri.toString()),
        body: await httpRequest.cast<List<int>>().transform(utf8.decoder).join());

    // Передача запроса на обработку роутеру
    var response = await router(request);

    // Отправка ответа клиенту
    httpRequest.response
      ..write(await response.readAsString())
      ..close();
  });
}
Future<void> sendMessageToChatMembers(String chatId, dynamic message) async {
  // TODO: Реализация отправки сообщения всем участникам чата
}

class Message {
  String uid;
  String cid;
  String message;
  Message({required this.uid, required this.message, required this.cid});
  @override
  String toString() {
    // TODO: implement toString
    return '$uid, $message, $cid';
  }
}