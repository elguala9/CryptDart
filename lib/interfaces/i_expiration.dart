import 'package:cryptdart/types/crypto_algorithm.dart';
import 'package:cryptdart/interfaces/i_base_expiration.dart';

/// Interface for expiration logic in cryptographic objects.
/// Provides expiration date, usage limits, and algorithm info.
abstract class IExpiration extends IBaseExpiration {
  /// Increments the usage counter for expiration times.
  void incrementUse();

  /// The cryptographic algorithm associated with this object.
  CryptoAlgorithm get algorithm;
}
