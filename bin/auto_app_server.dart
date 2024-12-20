import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_app_server/app_config/main_config.dart';
import 'package:auto_app_server/auth_user_from_sql.dart';
import 'package:auto_app_server/chat/chat.dart';
import 'package:auto_app_server/create_booking_from_sql.dart';
import 'package:auto_app_server/create_manager_car.dart';
import 'package:auto_app_server/create_user_car_from_sql.dart';
import 'package:auto_app_server/create_user_from_sql.dart';
import 'package:auto_app_server/get_booking_list_from_sql.dart';
import 'package:auto_app_server/get_car_list.dart';
import 'package:auto_app_server/profile/edit_profile.dart';
import 'package:auto_app_server/profile/get_wishlist.dart';
import 'package:auto_app_server/service/get_garages.dart';
import 'package:auto_app_server/get_user_cars_form_sql.dart';
import 'package:auto_app_server/like_car_from_sql.dart';
import 'package:auto_app_server/sell_car/sell_car_list.dart';
import 'package:auto_app_server/sell_car/sell_car_request.dart';
import 'package:auto_app_server/service/service_sql.dart';
import 'package:auto_app_server/user_sql.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async {
  Router router = Router();



  router.post('/reguser', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var user = await createUserFromSQL(
      sql: sql,
      name: data['name'],
      phone: data['phone'],
      email: data['email'],
      rules: data['rules'],
      password_hash: data['password_hash'],
    );
    await sql.close();
    return Response.ok(jsonEncode(user));
  });
  router.post('/getcarinfo', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var resp = await getCarInfo(data['id'], data['uid'], sql);
    await sql.close();
    return Response.ok(jsonEncode(resp));
  });
  router.post('/getServiceInfo', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    Map response = await getServiceInfo(data['cid'], sql);
    await sql.close();
    return Response.ok(jsonEncode(response));
  });
  router.post('/createServiceBlock', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await addServiceBlock(sql,
        sid: data['cid'], title: data['title'], included: data['included']);
    await sql.close();
    return Response.ok('created');
  });
  router.post('/updateServiceBlock', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await updateServiceBlock(sql, id: data['cid'], title: data['title']);
    await sql.close();
    return Response.ok('updated');
  });
  router.post('/deleteServiceBlock', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await deleteServiceBlock(sql, id: data['cid']);
    await sql.close();
    return Response.ok('deleted');
  });
  router.post('/deleteGarage', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await deleteGarage(sql, id: data['id']);
    await sql.close();
    return Response.ok('deleted');
  });
  router.post('/getWishlist', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final response = await getWishlist(data['uid'], sql);
    await sql.close();
    return Response.ok(jsonEncode(response));
  });
  router.post('/updateName', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    changeProfileName(sql, uid: data['uid'], name: data['name']);
    await sql.close();
    return Response.ok('changed');
  });
  router.post('/getsellrequests', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var resp = await getSellCarList(sql); //
    await sql.close();
    return Response.ok(jsonEncode(resp));
  });
  router.post('/editProfilePhoto', (Request request) async {
    return Response.ok('200');
  });
  router.post('/auth', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    print(data['email_or_phone']);
    print(data['password_hash']);
    var uid = await authUserFromSQL(
        sql: sql,
        email_or_phone: data['email_or_phone'],
        password_hash: data['password_hash']);
    await sql.close();
    return Response.ok(jsonEncode(uid));
  });
  router.post('/getcars', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    List rep = await getCarList(data['id'], sql);
    await sql.close();
    return Response.ok(jsonEncode(rep));
  });
  router.post('/sellcarrequest', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await sellCarRequest(
        sql: sql,
        type: data['type'].toString(),
        any_car_accidents: data['any_car_accidents'],
        uid: data['uid'],
        cid: data['cid'],
        gcc: data['gcc'],
        owner_email: data['owner_email'],
        owner_name: data['owner_name'],
        owner_phone: data['owner_phone'],
        servise_history: data['servise_history']);
    await sql.close();
    return Response.ok('ok');
  });
  router.post('/likecar', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    likeCarFromSql(uid: data['uid'], cid: data['cid'], sql: sql);
    await sql.close();
    return Response.ok('ok');
  });
  router.post('/dislikecar', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    dislikeCarFromSql(id: data['id'], sql: sql);
    await sql.close();
    return Response.ok('');
  });
  router.post('/createusercar', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    createUserCarFromSQL(
        sql: sql,
        uid: data['uid'].toString(),
        name: data['name'].toString(),
        brand: data['brand'].toString(),
        model: data['model'].toString(),
        year: data['year'].toString(),
        car_reg: data['car_reg'].toString());
    await sql.close();
    return Response.ok('');
  });
  router.post('/getusercars', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var rep = await getUserCarList(data['uid'], sql);
    await sql.close();
    return Response.ok(jsonEncode(rep));
  });
  router.post('/updateToken', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var rep = await updateUserToken(data['uid'], data['token'], sql);
    await sql.close();
    return Response.ok('ok');
  });
  router.post('/getBookingInfo', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var info = await getBookingInfo(sql, data['id']);
    await sql.close();
    return Response.ok(jsonEncode(info));
  });
  router.post('/getuserbooking', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var rep = await getUserBookingList(data['uid'], sql);
    await sql.close();
    return Response.ok(jsonEncode(rep));
  });
  router.post('/deleteCar', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await deleteCar(data['id'], sql);
    await sql.close();
    return Response.ok('deleted');
  });

  router.post('/deleteOffer', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await deleteSpeccialOffer(sql, data['id']);
    await sql.close();
    return Response.ok('deleted');
  });

  router.post('/setBookingGarage', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await setGarage(sql, id: data['id'], garage: data['garage']);
    await sql.close();
    return Response.ok('updated');
  });
  router.post('/updateService', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await updateServiceInfo(sql,
        id: data['id'],
        price: data['price'],
        priceMin: data['price_min'],
        description: data['description']);
    await sql.close();
    return Response.ok('updated');
  });
  router.post('/getmasterbooking', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var rep = await getUserBookingListMaster(data['cid'], sql);
    await sql.close();
    return Response.ok(jsonEncode(rep));
  });
  router.post('/editGarage', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    updateGarage(sql,
        name: data['name'],
        password: data['password'],
        phone: data['phone'],
        email: data['email'],
        id: data['id']);
    await sql.close();
    return Response.ok('updated');
  });
  router.get('/getmanagerbooking', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var rep = await getManagerBookingList(sql);
    await sql.close();
    return Response.ok(jsonEncode(rep));
  });
  router.get('/getManagerNewBooking', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var rep = await getManagerNewBookingList(sql);
    sql.close();
    return Response.ok(jsonEncode(rep));
  });
  router.post('/getnewmasterbooking', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var rep = await getNewBookingListMaster(data['cid'], sql);
    await sql.close();
    return Response.ok(jsonEncode(rep));
  });
  router.post('/getuserinfo', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var rep = await getUserInfo(data['uid'], sql);
    print('/getUserInfo');
    print(data['uid']);
    await sql.close();
    return Response.ok(jsonEncode(rep));
  });
  router.post('/updatebooking', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    updateBookingStatus(data['id'], data['status'], sql, data['reason'],data['garage']);
    await sql.close();
    return Response.ok('updated');
  });

  router.post('/updateusercars', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
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
    await sql.close();
    return Response.ok('');
  });
  router.post('/createbooking', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    createBookingFromSQL(
        sql: sql,
        description: data['description'],
        sid: data['sid'].toString(),
        cid: data['cid'].toString(),
        uid: data['uid'].toString(),
        owner_name: data['owner_name'].toString(),
        owner_email: data['owner_email'].toString(),
        owner_phone: data['owner_phone'].toString(),
        pickup: data['pickup'],
        delivery: data['delivery'],
        timestamp: data['timestamp'].toString(),
        date_time: data['date_time'].toString());
    await sql.close();
    return Response.ok('');
  });
  router.post('/createBookingOffer', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    createBookingSpecialOffer(
        description: data['description'],
        sql: sql,
        garage: data['garage'].toString(),
        sid: data['sid'].toString(),
        cid: data['cid'].toString(),
        uid: data['uid'].toString(),
        owner_name: data['owner_name'].toString(),
        owner_email: data['owner_email'].toString(),
        owner_phone: data['owner_phone'].toString(),
        pickup: data['pickup'],
        delivery: data['delivery'],
        timestamp: data['timestamp'].toString(),
        date_time: data['date_time'].toString());
    await sql.close();
    return Response.ok('');
  });

  router.post('/deleteusercar', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    deleteUserCarFromSql(id: data['id'], sql: sql);
    await sql.close();
    return Response.ok('');
  });
  router.post('/updateManagerCar', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await updateCarFromSQL(
        sql: sql,
        id: data['id'],
        name: data['name'].toString(),
        brand: data['brand'].toString(),
        model: data['model'].toString(),
        price_usd: data['price_usd'].toString(),
        price_aed: data['price_aed'].toString(),
        color: data['color'].toString(),
        killometers: data['killometers'].toString(),
        regional_specs: data['regional_specs'].toString(),
        transmission: data['transmission'].toString(),
        motor_trim: data['motor_trim'].toString(),
        body: data['body'].toString(),
        guarantee: data['guarantee'].toString(),
        service_contact: data['service_contact'].toString(),
        description: data['description'].toString(),
        year: data['year'].toString(),
        ccid: data['ccid'].toString(),
        cash: data['cash']);
    await sql.close();
    return Response.ok('');
  });


  router.post('/createchat', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    int response = await createChat(
        type: data['type'],
        uid1: data['uid1'],
        uid2: data['uid2'],
        chatSubject: data['cid'],
        sql: sql);
    await sql.close();
    return Response.ok(jsonEncode(response));
  });
  router.post('/getchats', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final response = await getUserChats(uid: data['uid'], sql: sql);
    await sql.close();
    return Response.ok(jsonEncode(response));
  });
  router.post('/updateManagerNumber', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await setManagerNumber(sql, data['phone']);
    await sql.close();
    return Response.ok('updated');
  });
  router.post('/editBooking', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await editBooking(sql, id: data['id'], dateTime: data['dateTime'], ownerName: data['ownerName'], ownerEmail: data['ownerEmail'], ownerPhone: data['ownerPhone'], delivery: data['delivery'], pickUp: data['pickUp']);
    await sql.close();
    return Response.ok('updated');
  });
  router.get('/getGarages', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    List response = await getGaragesList(sql);
    await sql.close();
    return Response.ok(jsonEncode(response));
  });
  router.post('/createOffer', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await createOffer(sql,
        name: data['name'],
        price: data['price'],
        low_price: data['low_price'],
        description: data['description'],
        garage: data['garage']);
    await sql.close();
    return Response.ok('created');
  });
  router.post('/getMessages', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final response = await getMessagesFromSQL(data['cid'], sql: sql);
    await sql.close();
    return Response.ok(jsonEncode(response));
  });
  router.post('/getLastOffers', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    final response = await getLastOffers(sql);
    await sql.close();
    return Response.ok(jsonEncode(response));
  });
  router.post('/getMyOffers', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final response = await getMyOffers(sql, garage: data['garage']);
    await sql.close();
    return Response.ok(jsonEncode(response));
  });
  router.post('/readMessages', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final response = await readMessages(data['cid'], data['uid'], sql);
    await sql.close();
    return Response.ok('reading');
  });
  router.post('/forgotPassword', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    bool response = await forgotPassword(data['email'], sql);
    await sql.close();
    return Response.ok(jsonEncode(response));
  });
  router.post('/sendMessage', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await createMessageFromSQL(
        cid: data['cid'], uid: data['uid'], msg: data['msg'], sql: sql,opponentId: data['opponent_id'], opponentName: data['opponent_name']);
    await sql.close();
    return Response.ok('created');
  });
  router.post('/create_car', (Request request) async {
    var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'autoapp',);
    await sql.connect(timeoutMs: 1000000000000000000);
    try {
      var requestBody = await request.readAsString();
      var data = jsonDecode(requestBody);
      var images = data['images'];
      var folderName = request.headers['folder-name'];
      var newFolder = Directory('images/$folderName');
      if (!await newFolder.exists()) {
        await newFolder.create(recursive: true);
      }
      for (var i = 0; i < images.length; i++) {
        var imageData = images[i];
        var imageBytes = base64Decode(imageData['data']);
        var imageName = imageData['name'];
        var filePath = 'images/$folderName/$imageName';

        var file = File(filePath);
        await file.writeAsBytes(imageBytes);
      }
      await createCarFromSQL(
          sql: sql,
          name: data['name'].toString(),
          brand: data['brand'].toString(),
          model: data['model'].toString(),
          price_usd: data['price_usd'].toString(),
          price_aed: data['price_aed'].toString(),
          color: data['color'].toString(),
          killometers: data['killometers'].toString(),
          regional_specs: data['regional_specs'].toString(),
          transmission: data['transmission'].toString(),
          motor_trim: data['motor_trim'].toString(),
          body: data['body'].toString(),
          guarantee: data['guarantee'].toString(),
          service_contact: data['service_contact'].toString(),
          description: data['description'].toString(),
          year: data['year'].toString(),
          ccid: data['ccid'].toString(),
          cash: data['cash']);
      await sql.close();
      return Response.ok('Images uploaded successfully');
    } catch (e) {
      await sql.close();
      return Response.internalServerError(body: 'Error: $e');
    }
  });
  router.get('/test_photo', (Request request) async {
    String? path = request.url.queryParameters['path'];
    var imagePathJpeg = 'images/$path/1.jpeg';
    var imagePathJpg = 'images/$path/1.jpg';
    try {
      var file = File(imagePathJpeg).existsSync()
          ? File(imagePathJpeg)
          : File(imagePathJpg);

      if (await file.exists()) {
        var bytes = await file.readAsBytes();

        return Response.ok(bytes, headers: {
          'Content-Type':
          File(imagePathJpeg).existsSync() ? 'image/jpeg' : 'image/jpg'
        });
      } else {
        return Response.notFound('File not found');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Error: $e');
    }
  });
  router.get('/avatar', (Request request) async {
    String? path = request.url.queryParameters['path'];
    var imagePathJpeg = 'images/$path.jpeg';
    var imagePathJpg = 'images/$path.jpg';
    try {
      var file = File(imagePathJpeg).existsSync()
          ? File(imagePathJpeg)
          : File(imagePathJpg);

      if (await file.exists()) {
        var bytes = await file.readAsBytes();

        return Response.ok(bytes, headers: {
          'Content-Type':
          File(imagePathJpeg).existsSync() ? 'image/jpeg' : 'image/jpg'
        });
      } else {
        return Response.notFound('File not found');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Error: $e');
    }
  });
  router.get('/get_photo', (Request request) async {
    String? path = request.url.queryParameters['path'];
    String? ind = request.url.queryParameters['ind'];
    var imagePathJpeg = 'images/$path/$ind.jpeg';
    var imagePathJpg = 'images/$path/$ind.jpg';

    try {
      var file = File(imagePathJpeg).existsSync() ? File(imagePathJpeg) : File(imagePathJpg);

      if (await file.exists()) {
        var bytes = await file.readAsBytes();

        return Response.ok(bytes, headers: {
          'Content-Type': File(imagePathJpeg).existsSync() ? 'image/jpeg' : 'image/jpg',
          'Cache-Control': 'public, max-age=86400'  // Кэширование на 1 день
        });
      } else {
        return Response.notFound('File not found');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Error: ${e.toString()}');
    }
  });
  router.post('/add_avatar', (Request request) async {
    var requestBody = await request.readAsString();
    var data = jsonDecode(requestBody);
    var imageData = data['image'];
    var imageBytes = base64Decode(imageData['data']);
    var imageName = imageData['name'];
    var filePath = 'images/$imageName';
    var file = File(filePath);
    if(file.existsSync() == true) {
      await file.delete();
    }
    await file.writeAsBytes(imageBytes);
    return Response.ok('');
  });

  await serve(router, '0.0.0.0', 2314);

}


