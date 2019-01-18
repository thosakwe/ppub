import 'package:angel_migration/angel_migration.dart';
import 'package:angel_model/angel_model.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:angel_orm/angel_orm.dart';
part 'uploader.g.dart';

@serializable
@orm
abstract class _Uploader extends Model {
  int get userId;

  int get packageId;
}
