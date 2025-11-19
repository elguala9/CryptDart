import 'i_cipher.dart';
import 'i_expiration.dart';
import 'i_sign.dart';

/// Interface for asymmetric key objects.
/// Extends [IExpiration] for expiration logic.
abstract interface class IAsymmetric extends IExpiration {
  /// The public key as a string.
  String get publicKey;

  /// The private key as a string (optional).
  String? get privateKey;

  /// Generates a new asymmetric key pair (to be implemented by concrete classes).
  static KeyPair generateKeyPair() {
    throw UnimplementedError('generateKeyPair needs to be implemented');
  }
}

/// Interface for asymmetric ciphers.
/// Combines [IAsymmetric] and [ICipher].
abstract interface class IAsymmetricCipher extends IAsymmetric implements ICipher {
  // publicKey, privateKey, generateKeyPair già definiti in IAsymmetric
}

/// Interface for asymmetric signature operations.
/// Combines [IAsymmetric] and [ISign].
abstract interface class IAsymmetricSign extends IAsymmetric implements ISign {
  // publicKey, privateKey, generateKeyPair già definiti in IAsymmetric
}

/// Typedef for an asymmetric key pair (public and private keys).
typedef KeyPair = ({
  String publicKey,
  String privateKey,
});