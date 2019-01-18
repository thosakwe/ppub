// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class PackageMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('packages', (table) {
      table.serial('id')..primaryKey();
      table.varChar('name');
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('packages');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class PackageQuery extends Query<Package, PackageQueryWhere> {
  PackageQuery() {
    _where = new PackageQueryWhere(this);
    leftJoin(
        '(' + new PackageVersionQuery().compile() + ')', 'id', 'package_id',
        additionalFields: const [
          'package_id',
          'archive_url',
          'pubspec_yaml',
          'version_string',
          'created_at',
          'updated_at'
        ]);
  }

  @override
  final PackageQueryValues values = new PackageQueryValues();

  PackageQueryWhere _where;

  @override
  get tableName {
    return 'packages';
  }

  @override
  get fields {
    return const ['id', 'name', 'created_at', 'updated_at'];
  }

  @override
  PackageQueryWhere get where {
    return _where;
  }

  @override
  PackageQueryWhere newWhereClause() {
    return new PackageQueryWhere(this);
  }

  static Package parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = new Package(
        id: row[0].toString(),
        name: (row[1] as String),
        createdAt: (row[2] as DateTime),
        updatedAt: (row[3] as DateTime));
    if (row.length > 4) {
      model = model.copyWith(
          versions: [PackageVersionQuery.parseRow(row.skip(4).toList())]
              .where((x) => x != null)
              .toList());
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }

  @override
  get(QueryExecutor executor) {
    return super.get(executor).then((result) {
      return result.fold<List<Package>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
                versions: List<PackageVersion>.from(l.versions ?? [])
                  ..addAll(model.versions ?? []));
        }
      });
    });
  }

  @override
  update(QueryExecutor executor) {
    return super.update(executor).then((result) {
      return result.fold<List<Package>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
                versions: List<PackageVersion>.from(l.versions ?? [])
                  ..addAll(model.versions ?? []));
        }
      });
    });
  }

  @override
  delete(QueryExecutor executor) {
    return super.delete(executor).then((result) {
      return result.fold<List<Package>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
                versions: List<PackageVersion>.from(l.versions ?? [])
                  ..addAll(model.versions ?? []));
        }
      });
    });
  }
}

class PackageQueryWhere extends QueryWhere {
  PackageQueryWhere(PackageQuery query)
      : id = new NumericSqlExpressionBuilder<int>(query, 'id'),
        name = new StringSqlExpressionBuilder(query, 'name'),
        createdAt = new DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = new DateTimeSqlExpressionBuilder(query, 'updated_at');

  final NumericSqlExpressionBuilder<int> id;

  final StringSqlExpressionBuilder name;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  @override
  get expressionBuilders {
    return [id, name, createdAt, updatedAt];
  }
}

class PackageQueryValues extends MapQueryValues {
  int get id {
    return (values['id'] as int);
  }

  set id(int value) => values['id'] = value;
  String get name {
    return (values['name'] as String);
  }

  set name(String value) => values['name'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  void copyFrom(Package model) {
    values.addAll({
      'name': model.name,
      'created_at': model.createdAt,
      'updated_at': model.updatedAt
    });
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Package extends _Package {
  Package(
      {this.id,
      this.name,
      List<PackageVersion> versions,
      this.createdAt,
      this.updatedAt})
      : this.versions = new List.unmodifiable(versions ?? []);

  @override
  final String id;

  @override
  final String name;

  @override
  final List<PackageVersion> versions;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  Package copyWith(
      {String id,
      String name,
      List<PackageVersion> versions,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new Package(
        id: id ?? this.id,
        name: name ?? this.name,
        versions: versions ?? this.versions,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _Package &&
        other.id == id &&
        other.name == name &&
        const ListEquality<PackageVersion>(
                const DefaultEquality<PackageVersion>())
            .equals(other.versions, versions) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects([id, name, versions, createdAt, updatedAt]);
  }

  Map<String, dynamic> toJson() {
    return PackageSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class PackageSerializer {
  static Package fromMap(Map map) {
    return new Package(
        id: map['id'] as String,
        name: map['name'] as String,
        versions: map['versions'] is Iterable
            ? new List.unmodifiable(((map['versions'] as Iterable)
                    .where((x) => x is Map) as Iterable<Map>)
                .map(PackageVersionSerializer.fromMap))
            : null,
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

  static Map<String, dynamic> toMap(_Package model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'name': model.name,
      'versions': model.versions
          ?.map((m) => PackageVersionSerializer.toMap(m))
          ?.toList(),
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class PackageFields {
  static const List<String> allFields = const <String>[
    id,
    name,
    versions,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String name = 'name';

  static const String versions = 'versions';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
