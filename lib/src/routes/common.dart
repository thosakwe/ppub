import 'dart:convert';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:private_pub/models.dart';

Future<bool> resolveUser(RequestContext req, ResponseContext res) async {
  if (req.headers.value('authorization')?.startsWith('Basic') != true) {
    throw AngelHttpException.badRequest(message: 'Missing Basic auth header.');
  } else {
    var basicValue = req.headers.value('authorization').substring(5).trim();
    var userInfo = utf8.decode(base64Url.decode(basicValue));
    var s = userInfo.split(':');

    if (s.length != 2) {
      throw AngelHttpException.badRequest(
          message: 'Invalid Basic auth header.');
    }

    var email = s[0].toLowerCase(), password = s[1];
    var executor = req.container.make<QueryExecutor>();
    var crypt = DBCrypt();
    var query = UserQuery()..where.email.equals(email);
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
