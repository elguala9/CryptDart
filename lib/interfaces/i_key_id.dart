import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'i_expiration.dart';
import 'package:crypto/crypto.dart';

/// Interface that declares the keyId.
/// Returns SHA-256 hash of the key material as a hex string.
@includeInBarrelFile
abstract interface class IKeyId extends IExpiration {
  /// Returns the SHA-256 hash of the key material as a hex string.
  ///
  /// This provides a consistent, cryptographically secure identifier
  /// for the key, rather than relying on memory addresses (hashCode).
  Digest get keyId;
}