import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'i_cipher.dart';
import 'i_expiration.dart';
import 'i_key_id.dart';
import 'i_sign.dart';

/// Interface for symmetric key objects.
/// Extends [IExpiration] for expiration logic.
@includeInBarrelFile
abstract interface class ISymmetric extends IExpiration implements IKeyId {
  /// The symmetric key as a string.
  String get key;
  @override
  int get keyId => key.hashCode;

  /// Generates a new symmetric key (to be implemented by concrete classes).
  static String generateKey() {
    throw UnimplementedError('generateKey needs to be implemented');
  }
}

/// Interface for symmetric ciphers.
/// Combines [ICipher] and [ISymmetric].
abstract interface class ISymmetricCipher extends ICipher
    implements ISymmetric {}

/// Interface for symmetric signature operations.
/// Combines [ISymmetric] and [ISign].
abstract interface class ISymmetricSign extends ISymmetric implements ISign {}
