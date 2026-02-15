import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_key_id.dart';
import 'i_expiration.dart';

/// Base interface for all cipher implementations.
/// Extends [IExpiration] to support expiration logic.
@includeInBarrelFile
abstract class ICipher extends IExpiration implements IKeyId {
  /// Defines encryption and decryption operations for ciphers.
  /// Encrypts the given data.
  List<int> encrypt(List<int> data);

  /// Decrypts the given data.
  List<int> decrypt(List<int> data);
}
