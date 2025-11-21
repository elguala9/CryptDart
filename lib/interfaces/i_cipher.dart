import 'i_expiration.dart';

/// Base interface for all cipher implementations.
/// Extends [IExpiration] to support expiration logic.

abstract class ICipher extends IExpiration {
  /// Defines encryption and decryption operations for ciphers.
  /// Encrypts the given data.
  List<int> encrypt(List<int> data);

  /// Decrypts the given data.
  List<int> decrypt(List<int> data);
}
