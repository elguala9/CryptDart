import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'i_expiration.dart';

/// Interface that declare the keyId
@includeInBarrelFile
abstract interface class IKeyId extends IExpiration {
  int get keyId;
}