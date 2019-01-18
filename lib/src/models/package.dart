import 'package:angel_migration/angel_migration.dart';
import 'package:angel_model/angel_model.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:collection/collection.dart';
import 'package_version.dart';
part 'package.g.dart';

@serializable
@orm
abstract class _Package extends Model {
  String get name;

  @hasMany
  List<PackageVersion> get versions;

  Map<String, dynamic> toApiJson() {
    var sortedVersions =
        List<PackageVersion>.from(versions.where((v) => v != null))
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    var latest =
        sortedVersions.isEmpty ? null : sortedVersions.first.toApiJson();
    return {
      'name': name,
      'latest': latest,
      'versions': sortedVersions.map((v) => v.toApiJson()).toList(),
    };
  }
}
