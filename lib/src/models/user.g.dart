// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class UserMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('users', (table) {
      table.serial('id')..primaryKey();
      table.varChar('username');
      table.varChar('email');
      table.varChar('hashed_password');
      table.varChar('salt');
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('users');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class UserQuery extends Query<User, UserQueryWhere> {
  UserQuery({Set<String> trampoline}) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = UserQueryWhere(this);
  }

  @override
  final UserQueryValues values = UserQueryValues();

  UserQueryWhere _where;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'users';
  }

  @override
  get fields {
    return const [
      'id',
      'username',
      'email',
      'hashed_password',
      'salt',
      'created_at',
      'updated_at'
    ];
  }

  @override
  UserQueryWhere get where {
    return _where;
  }

  @override
  UserQueryWhere newWhereClause() {
    return UserQueryWhere(this);
  }

  static User parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = User(
        id: row[0].toString(),
        username: (row[1] as String),
        email: (row[2] as String),
        hashedPassword: (row[3] as String),
        salt: (row[4] as String),
        createdAt: (row[5] as DateTime),
        updatedAt: (row[6] as DateTime));
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }
}

class UserQueryWhere extends QueryWhere {
  UserQueryWhere(UserQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        username = StringSqlExpressionBuilder(query, 'username'),
        email = StringSqlExpressionBuilder(query, 'email'),
        hashedPassword = StringSqlExpressionBuilder(query, 'hashed_password'),
        salt = StringSqlExpressionBuilder(query, 'salt'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at');

  final NumericSqlExpressionBuilder<int> id;

  final StringSqlExpressionBuilder username;

  final StringSqlExpressionBuilder email;

  final StringSqlExpressionBuilder hashedPassword;

  final StringSqlExpressionBuilder salt;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  @override
  get expressionBuilders {
    return [id, username, email, hashedPassword, salt, createdAt, updatedAt];
  }
}

class UserQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  int get id {
    return (values['id'] as int);
  }

  set id(int value) => values['id'] = value;
  String get username {
    return (values['username'] as String);
  }

  set username(String value) => values['username'] = value;
  String get email {
    return (values['email'] as String);
  }

  set email(String value) => values['email'] = value;
  String get hashedPassword {
    return (values['hashed_password'] as String);
  }

  set hashedPassword(String value) => values['hashed_password'] = value;
  String get salt {
    return (values['salt'] as String);
  }

  set salt(String value) => values['salt'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  void copyFrom(User model) {
    username = model.username;
    email = model.email;
    hashedPassword = model.hashedPassword;
    salt = model.salt;
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class User extends _User {
  User(
      {this.id,
      this.username,
      this.email,
      this.hashedPassword,
      this.salt,
      this.createdAt,
      this.updatedAt});

  @override
  final String id;

  @override
  final String username;

  @override
  final String email;

  @override
  final String hashedPassword;

  @override
  final String salt;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  User copyWith(
      {String id,
      String username,
      String email,
      String hashedPassword,
      String salt,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        hashedPassword: hashedPassword ?? this.hashedPassword,
        salt: salt ?? this.salt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _User &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.hashedPassword == hashedPassword &&
        other.salt == salt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects(
        [id, username, email, hashedPassword, salt, createdAt, updatedAt]);
  }

  Map<String, dynamic> toJson() {
    return UserSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class UserSerializer {
  static User fromMap(Map map) {
    return new User(
        id: map['id'] as String,
        username: map['username'] as String,
        email: map['email'] as String,
        hashedPassword: map['hashed_password'] as String,
        salt: map['salt'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null);
  }

  static Map<String, dynamic> toMap(_User model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'username': model.username,
      'email': model.email,
      'hashed_password': model.hashedPassword,
      'salt': model.salt,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class UserFields {
  static const List<String> allFields = <String>[
    id,
    username,
    email,
    hashedPassword,
    salt,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String username = 'username';

  static const String email = 'email';

  static const String hashedPassword = 'hashed_password';

  static const String salt = 'salt';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
