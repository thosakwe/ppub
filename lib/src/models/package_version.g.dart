// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_version.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class PackageVersionMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('package_versions', (table) {
      table.serial('id')..primaryKey();
      table.integer('package_id');
      table.varChar('archive_url');
      table.declare('pubspec_map', ColumnType('jsonb'));
      table.varChar('version_string');
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('package_versions');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class PackageVersionQuery
    extends Query<PackageVersion, PackageVersionQueryWhere> {
  PackageVersionQuery({Set<String> trampoline}) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = PackageVersionQueryWhere(this);
  }

  @override
  final PackageVersionQueryValues values = PackageVersionQueryValues();

  PackageVersionQueryWhere _where;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'package_versions';
  }

  @override
  get fields {
    return const [
      'id',
      'package_id',
      'archive_url',
      'pubspec_map',
      'version_string',
      'created_at',
      'updated_at'
    ];
  }

  @override
  PackageVersionQueryWhere get where {
    return _where;
  }

  @override
  PackageVersionQueryWhere newWhereClause() {
    return PackageVersionQueryWhere(this);
  }

  static PackageVersion parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = PackageVersion(
        id: row[0].toString(),
        packageId: (row[1] as int),
        archiveUrl: (row[2] as String),
        pubspecMap: (row[3] as Map<dynamic, dynamic>),
        versionString: (row[4] as String),
        createdAt: (row[5] as DateTime),
        updatedAt: (row[6] as DateTime));
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }
}

class PackageVersionQueryWhere extends QueryWhere {
  PackageVersionQueryWhere(PackageVersionQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        packageId = NumericSqlExpressionBuilder<int>(query, 'package_id'),
        archiveUrl = StringSqlExpressionBuilder(query, 'archive_url'),
        pubspecMap = MapSqlExpressionBuilder(query, 'pubspec_map'),
        versionString = StringSqlExpressionBuilder(query, 'version_string'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at');

  final NumericSqlExpressionBuilder<int> id;

  final NumericSqlExpressionBuilder<int> packageId;

  final StringSqlExpressionBuilder archiveUrl;

  final MapSqlExpressionBuilder pubspecMap;

  final StringSqlExpressionBuilder versionString;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  @override
  get expressionBuilders {
    return [
      id,
      packageId,
      archiveUrl,
      pubspecMap,
      versionString,
      createdAt,
      updatedAt
    ];
  }
}

class PackageVersionQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  int get id {
    return (values['id'] as int);
  }

  set id(int value) => values['id'] = value;
  int get packageId {
    return (values['package_id'] as int);
  }

  set packageId(int value) => values['package_id'] = value;
  String get archiveUrl {
    return (values['archive_url'] as String);
  }

  set archiveUrl(String value) => values['archive_url'] = value;
  Map<dynamic, dynamic> get pubspecMap {
    return (values['pubspec_map'] as Map<dynamic, dynamic>);
  }

  set pubspecMap(Map<dynamic, dynamic> value) => values['pubspec_map'] = value;
  String get versionString {
    return (values['version_string'] as String);
  }

  set versionString(String value) => values['version_string'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  void copyFrom(PackageVersion model) {
    packageId = model.packageId;
    archiveUrl = model.archiveUrl;
    pubspecMap = model.pubspecMap;
    versionString = model.versionString;
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class PackageVersion extends _PackageVersion {
  PackageVersion(
      {this.id,
      this.packageId,
      this.archiveUrl,
      Map<dynamic, dynamic> pubspecMap,
      this.versionString,
      this.createdAt,
      this.updatedAt})
      : this.pubspecMap = new Map.unmodifiable(pubspecMap ?? {});

  @override
  final String id;

  @override
  final int packageId;

  @override
  final String archiveUrl;

  @override
  final Map<dynamic, dynamic> pubspecMap;

  @override
  final String versionString;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  PackageVersion copyWith(
      {String id,
      int packageId,
      String archiveUrl,
      Map<dynamic, dynamic> pubspecMap,
      String versionString,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new PackageVersion(
        id: id ?? this.id,
        packageId: packageId ?? this.packageId,
        archiveUrl: archiveUrl ?? this.archiveUrl,
        pubspecMap: pubspecMap ?? this.pubspecMap,
        versionString: versionString ?? this.versionString,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _PackageVersion &&
        other.id == id &&
        other.packageId == packageId &&
        other.archiveUrl == archiveUrl &&
        const MapEquality<dynamic, dynamic>(
                keys: const DefaultEquality(), values: const DefaultEquality())
            .equals(other.pubspecMap, pubspecMap) &&
        other.versionString == versionString &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      packageId,
      archiveUrl,
      pubspecMap,
      versionString,
      createdAt,
      updatedAt
    ]);
  }

  Map<String, dynamic> toJson() {
    return PackageVersionSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class PackageVersionSerializer {
  static PackageVersion fromMap(Map map) {
    return new PackageVersion(
        id: map['id'] as String,
        packageId: map['package_id'] as int,
        archiveUrl: map['archive_url'] as String,
        pubspecMap: map['pubspec_map'] is Map
            ? (map['pubspec_map'] as Map).cast<dynamic, dynamic>()
            : null,
        versionString: map['version_string'] as String,
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

  static Map<String, dynamic> toMap(_PackageVersion model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'package_id': model.packageId,
      'archive_url': model.archiveUrl,
      'pubspec_map': model.pubspecMap,
      'version_string': model.versionString,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class PackageVersionFields {
  static const List<String> allFields = <String>[
    id,
    packageId,
    archiveUrl,
    pubspecMap,
    versionString,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String packageId = 'package_id';

  static const String archiveUrl = 'archive_url';

  static const String pubspecMap = 'pubspec_map';

  static const String versionString = 'version_string';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
