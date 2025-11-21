import 'package:cryptdart/types/crypto_algorithm.dart';

/// Interface for expiration logic in cryptographic objects.
/// Provides expiration date, usage limits, and algorithm info.
abstract class IExpiration {
  /// Returns true if the object is expired.
  bool isExpired();

  /// The expiration date, or null if not set.
  DateTime? get expirationDate;

  /// Maximum number of allowed usages before expiration.
  int? get expirationTimes;

  /// Remaining number of allowed usages.
  int? get expirationTimesRemaining;

  /// The cryptographic algorithm associated with this object.
  CryptoAlgorithm get algorithm;
}
