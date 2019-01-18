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
      table.varChar('pubspec_yaml');
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
  PackageVersionQuery() {
    _where = new PackageVersionQueryWhere(this);
  }

  @override
  final PackageVersionQueryValues values = new PackageVersionQueryValues();

  PackageVersionQueryWhere _where;

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
      'pubspec_yaml',
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
    return new PackageVersionQueryWhere(this);
  }

  static PackageVersion parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = new PackageVersion(
        id: row[0].toString(),
        packageId: (row[1] as int),
        archiveUrl: (row[2] as String),
        pubspecYaml: (row[3] as String),
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
      : id = new NumericSqlExpressionBuilder<int>(query, 'id'),
        packageId = new NumericSqlExpressionBuilder<int>(query, 'package_id'),
        archiveUrl = new StringSqlExpressionBuilder(query, 'archive_url'),
        pubspecYaml = new StringSqlExpressionBuilder(query, 'pubspec_yaml'),
        versionString = new StringSqlExpressionBuilder(query, 'version_string'),
        createdAt = new DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = new DateTimeSqlExpressionBuilder(query, 'updated_at');

  final NumericSqlExpressionBuilder<int> id;

  final NumericSqlExpressionBuilder<int> packageId;

  final StringSqlExpressionBuilder archiveUrl;

  final StringSqlExpressionBuilder pubspecYaml;

  final StringSqlExpressionBuilder versionString;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  @override
  get expressionBuilders {
    return [
      id,
      packageId,
      archiveUrl,
      pubspecYaml,
      versionString,
      createdAt,
      updatedAt
    ];
  }
}

class PackageVersionQueryValues extends MapQueryValues {
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
  String get pubspecYaml {
    return (values['pubspec_yaml'] as String);
  }

  set pubspecYaml(String value) => values['pubspec_yaml'] = value;
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
    values.addAll({
      'package_id': model.packageId,
      'archive_url': model.archiveUrl,
      'pubspec_yaml': model.pubspecYaml,
      'version_string': model.versionString,
      'created_at': model.createdAt,
      'updated_at': model.updatedAt
    });
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
      this.pubspecYaml,
      this.versionString,
      this.createdAt,
      this.updatedAt});

  @override
  final String id;

  @override
  final int packageId;

  @override
  final String archiveUrl;

  @override
  final String pubspecYaml;

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
      String pubspecYaml,
      String versionString,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new PackageVersion(
        id: id ?? this.id,
        packageId: packageId ?? this.packageId,
        archiveUrl: archiveUrl ?? this.archiveUrl,
        pubspecYaml: pubspecYaml ?? this.pubspecYaml,
        versionString: versionString ?? this.versionString,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _PackageVersion &&
        other.id == id &&
        other.packageId == packageId &&
        other.archiveUrl == archiveUrl &&
        other.pubspecYaml == pubspecYaml &&
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
      pubspecYaml,
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
        pubspecYaml: map['pubspec_yaml'] as String,
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
      'pubspec_yaml': model.pubspecYaml,
      'version_string': model.versionString,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class PackageVersionFields {
  static const List<String> allFields = const <String>[
    id,
    packageId,
    archiveUrl,
    pubspecYaml,
    versionString,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String packageId = 'package_id';

  static const String archiveUrl = 'archive_url';

  static const String pubspecYaml = 'pubspec_yaml';

  static const String versionString = 'version_string';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
