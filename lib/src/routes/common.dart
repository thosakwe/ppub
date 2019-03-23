import 'dart:async';
import 'dart:convert';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:googleapis/oauth2/v2.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/io_client.dart' as http;
import 'package:private_pub/models.dart';

Future<bool> resolveUser(RequestContext req, ResponseContext res) async {
  if (req.headers.value('authorization')?.startsWith('Bearer ') == true) {
    var tokenData = req.headers.value('authorization').substring(7);
    var token = AccessToken(
        'Bearer', tokenData, DateTime.now().add(Duration(minutes: 1)).toUtc());
    var credentials = AccessCredentials(
        token, null, ['https://www.googleapis.com/auth/userinfo.email']);
    var clientId = ClientId(
        '818368855108-8grd2eg9tj9f38os6f1urbcvsq399u8n.apps.'
        'googleusercontent.com',
        'SWeqj8seoJW0w7_CpEPFLX0K');
    var client = authenticatedClient(http.IOClient(), credentials);
    var oauth2 = Oauth2Api(client);
    var me = await oauth2.userinfo.v2.me.get();
    print(me.toJson()); 
    // var client = autoRefreshingClient(clientId, credentials, http.IOClient());
    throw me.toJson();
  } else if (req.headers.value('authorization')?.startsWith('Basic') != true) {
    throw AngelHttpException.badRequest(message: 'Missing Basic auth header.');
  } else {
    var basicValue = req.headers.value('authorization').substring(5).trim();
    var userInfo = utf8.decode(base64Url.decode(basicValue));
    var s = userInfo.split(':');

    if (s.length != 2) {
      throw AngelHttpException.badRequest(
          message: 'Invalid Basic auth header.');
    }

    var username = s[0].toLowerCase(), password = s[1];
    print([username, password]);
    var executor = req.container.make<QueryExecutor>();
    var crypt = DBCrypt();
    var query = UserQuery()..where.username.equals(username);
    var user = await query.getOne(executor);

    if (user == null) {
      throw AngelHttpException.notFound(
          message: 'Invalid or nonexistent user.');
    }

    var hash = crypt.hashpw(password, user.salt);

    if (hash != user.hashedPassword) {
      // TODO: Brute-force protection?
      throw AngelHttpException.badRequest(message: 'Invalid password.');
    }

    req.container.registerSingleton(user);
    return true;
  }
}
