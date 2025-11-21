import 'package:cryptdart/types/crypto_algorithm.dart';
import 'package:cryptdart/interfaces/i_expiration.dart';

/// Input parameters for [ExpirationBase] constructor.
typedef InputExpirationBase = ({
  CryptoAlgorithm algorithm,
  DateTime? expirationDate,
  int? expirationTimes,
});

/// Base class for expiration logic in cryptographic objects.
/// Implements [IExpiration] and manages expiration date, usage limits, and algorithm.
class ExpirationBase implements IExpiration {
  final DateTime? _expirationDate;
  final int? _expirationTimes;
  int? _expirationTimesRemaining;
  final CryptoAlgorithm _algorithm;

  /// Constructs an [ExpirationBase] with the given input parameters.
  ExpirationBase(InputExpirationBase input)
      : _algorithm = input.algorithm,
        _expirationDate = input.expirationDate,
        _expirationTimes = input.expirationTimes;

  @override
  bool isExpired() {
    if (_expirationTimesRemaining != null && _expirationTimesRemaining! <= 0)
      return true;
    if (_expirationDate != null)
      return DateTime.now().isAfter(_expirationDate!);
    return true;
  }

  @override
  DateTime? get expirationDate => _expirationDate;

  @override
  int? get expirationTimes => _expirationTimes;

  @override
  int? get expirationTimesRemaining => _expirationTimesRemaining;

  @override
  CryptoAlgorithm get algorithm => _algorithm;
}
