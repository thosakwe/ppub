import 'package:angel_migration/angel_migration.dart';
import 'package:angel_model/angel_model.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:yaml/yaml.dart' as yaml;
part 'package_version.g.dart';

@serializable
@orm
abstract class _PackageVersion extends Model {
  int get packageId;

  String get archiveUrl;

  String get pubspecYaml;

  String get versionString;

  Version get version => Version.parse(versionString);

  Pubspec parsePubspec() => Pubspec.parse(pubspecYaml, lenient: true);

  Map<String, dynamic> toApiJson() {
    return {
      'version': versionString,
      'archive_url': archiveUrl,
      'pubspec': yaml.loadYaml(pubspecYaml)
    };
  }
}
