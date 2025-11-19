import 'i_expiration.dart';

/// Interface for digital signature operations.
/// Extends [IExpiration] for expiration logic.
abstract interface class ISign extends IExpiration {
  /// Signs the given data and returns the signature as bytes.
  List<int> sign(List<int> data);

  /// Verifies the given data against a signature.
  bool verify(List<int> data);
}