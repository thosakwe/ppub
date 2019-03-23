// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploader.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class UploaderMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('uploaders', (table) {
      table.serial('id')..primaryKey();
      table.integer('user_id');
      table.integer('package_id');
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('uploaders');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class UploaderQuery extends Query<Uploader, UploaderQueryWhere> {
  UploaderQuery({Set<String> trampoline}) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = UploaderQueryWhere(this);
  }

  @override
  final UploaderQueryValues values = UploaderQueryValues();

  UploaderQueryWhere _where;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'uploaders';
  }

  @override
  get fields {
    return const ['id', 'user_id', 'package_id', 'created_at', 'updated_at'];
  }

  @override
  UploaderQueryWhere get where {
    return _where;
  }

  @override
  UploaderQueryWhere newWhereClause() {
    return UploaderQueryWhere(this);
  }

  static Uploader parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = Uploader(
        id: row[0].toString(),
        userId: (row[1] as int),
        packageId: (row[2] as int),
        createdAt: (row[3] as DateTime),
        updatedAt: (row[4] as DateTime));
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }
}

class UploaderQueryWhere extends QueryWhere {
  UploaderQueryWhere(UploaderQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        userId = NumericSqlExpressionBuilder<int>(query, 'user_id'),
        packageId = NumericSqlExpressionBuilder<int>(query, 'package_id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at');

  final NumericSqlExpressionBuilder<int> id;

  final NumericSqlExpressionBuilder<int> userId;

  final NumericSqlExpressionBuilder<int> packageId;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  @override
  get expressionBuilders {
    return [id, userId, packageId, createdAt, updatedAt];
  }
}

class UploaderQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  int get id {
    return (values['id'] as int);
  }

  set id(int value) => values['id'] = value;
  int get userId {
    return (values['user_id'] as int);
  }

  set userId(int value) => values['user_id'] = value;
  int get packageId {
    return (values['package_id'] as int);
  }

  set packageId(int value) => values['package_id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  void copyFrom(Uploader model) {
    userId = model.userId;
    packageId = model.packageId;
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Uploader extends _Uploader {
  Uploader(
      {this.id, this.userId, this.packageId, this.createdAt, this.updatedAt});

  @override
  final String id;

  @override
  final int userId;

  @override
  final int packageId;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  Uploader copyWith(
      {String id,
      int userId,
      int packageId,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new Uploader(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        packageId: packageId ?? this.packageId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _Uploader &&
        other.id == id &&
        other.userId == userId &&
        other.packageId == packageId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects([id, userId, packageId, createdAt, updatedAt]);
  }

  Map<String, dynamic> toJson() {
    return UploaderSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class UploaderSerializer {
  static Uploader fromMap(Map map) {
    return new Uploader(
        id: map['id'] as String,
        userId: map['user_id'] as int,
        packageId: map['package_id'] as int,
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

  static Map<String, dynamic> toMap(_Uploader model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'user_id': model.userId,
      'package_id': model.packageId,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class UploaderFields {
  static const List<String> allFields = <String>[
    id,
    userId,
    packageId,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String userId = 'user_id';

  static const String packageId = 'package_id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
