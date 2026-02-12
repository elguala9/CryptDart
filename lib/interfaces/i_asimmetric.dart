import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/utils/crypto_utils.dart';
import 'i_cipher.dart';
import 'i_expiration.dart';
import 'i_key_id.dart';
import 'i_sign.dart';
import 'package:crypto/crypto.dart';


/// Mixin for asymmetric key objects.
/// Provides SHA-256 based keyId implementation using the public key.
/// Must be mixed into classes that extend [IExpiration].
@includeInBarrelFile
mixin IAsymmetric on IExpiration implements IKeyId {
  /// The public key as a string.
  String get publicKey;

  /// The private key as a string (optional).
  String? get privateKey;

  @override
  Digest get keyId => SymmetricKeyUtils.sha256From(publicKey);

  /// Generates a new asymmetric key pair (to be implemented by concrete classes).
  static KeyPair generateKeyPair() {
    throw UnimplementedError('generateKeyPair needs to be implemented');
  }
}

/// Interface for asymmetric ciphers.
/// Combines [IAsymmetric] and [ICipher].
abstract interface class IAsymmetricCipher extends ICipher
    implements IAsymmetric {}

/// Interface for asymmetric signature operations.
/// Combines [IAsymmetric] and [ISign].
abstract interface class IAsymmetricSign implements IAsymmetric, ISign {}

/// Typedef for an asymmetric key pair (public and private keys).
typedef KeyPair = ({
  String publicKey,
  String privateKey,
});
