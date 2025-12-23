/// Base interface for expiration logic in cryptographic objects.
/// Provides expiration date and usage limits.
abstract class IBaseExpiration {
  /// Returns true if the object is expired.
  bool isExpired();

  /// The expiration date, or null if not set.
  DateTime? get expirationDate;

  /// Maximum number of allowed usages before expiration.
  int? get expirationTimes;

  /// Remaining number of allowed usages.
  int? get expirationTimesRemaining;
}