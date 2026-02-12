import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/utils/crypto_utils.dart';
import 'i_cipher.dart';
import 'i_expiration.dart';
import 'i_key_id.dart';
import 'i_sign.dart';
import 'package:crypto/crypto.dart';

/// Mixin for symmetric key objects.
/// Provides SHA-256 based keyId implementation.
/// Must be mixed into classes that extend [IExpiration].
@includeInBarrelFile
mixin ISymmetric on IExpiration implements IKeyId {
  /// The symmetric key as a string.
  String get key;

  @override
  Digest get keyId => SymmetricKeyUtils.sha256From(key);

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
abstract interface class ISymmetricSign implements ISymmetric, ISign {}
