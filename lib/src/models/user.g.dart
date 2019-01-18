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
  UserQuery() {
    _where = new UserQueryWhere(this);
  }

  @override
  final UserQueryValues values = new UserQueryValues();

  UserQueryWhere _where;

  @override
  get tableName {
    return 'users';
  }

  @override
  get fields {
    return const ['id', 'created_at', 'updated_at'];
  }

  @override
  UserQueryWhere get where {
    return _where;
  }

  @override
  UserQueryWhere newWhereClause() {
    return new UserQueryWhere(this);
  }

  static User parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = new User(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime));
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }
}

class UserQueryWhere extends QueryWhere {
  UserQueryWhere(UserQuery query)
      : id = new NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = new DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = new DateTimeSqlExpressionBuilder(query, 'updated_at');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  @override
  get expressionBuilders {
    return [id, createdAt, updatedAt];
  }
}

class UserQueryValues extends MapQueryValues {
  int get id {
    return (values['id'] as int);
  }

  set id(int value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  void copyFrom(User model) {
    values
        .addAll({'created_at': model.createdAt, 'updated_at': model.updatedAt});
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class User extends _User {
  User({this.id, this.createdAt, this.updatedAt});

  @override
  final String id;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  User copyWith({String id, DateTime createdAt, DateTime updatedAt}) {
    return new User(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _User &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects([id, createdAt, updatedAt]);
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
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class UserFields {
  static const List<String> allFields = const <String>[
    id,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
