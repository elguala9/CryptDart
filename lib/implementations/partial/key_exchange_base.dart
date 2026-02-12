import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/types/key_exchange_algorithm.dart';
import 'package:cryptdart/interfaces/i_base_expiration.dart';

/// Input parameters for [KeyExchangeBase] constructor.
typedef InputKeyExchangeBase = ({
  KeyExchangeAlgorithm algorithm,
  DateTime? expirationDate,
  int? expirationTimes,
});

/// Base class for key exchange implementations with expiration logic.
/// Implements [IBaseExpiration] and manages expiration date, usage limits, and key exchange algorithm.
@includeInBarrelFile
class KeyExchangeBase implements IBaseExpiration {
  final DateTime? _expirationDate;
  final int? _expirationTimes;
  int? _expirationTimesRemaining;
  final KeyExchangeAlgorithm _algorithm;

  /// Constructs a [KeyExchangeBase] with the given input parameters.
  KeyExchangeBase(InputKeyExchangeBase input)
      : _algorithm = input.algorithm,
        _expirationDate = input.expirationDate,
        _expirationTimes = input.expirationTimes;

  @override
  bool isExpired() {
    if (_expirationTimesRemaining != null && _expirationTimesRemaining! <= 0)
      return true;
    if (_expirationDate != null)
      return DateTime.now().isAfter(_expirationDate!);
    return false;
  }

  @override
  void incrementUse() {
    if (_expirationTimes != null) {
      _expirationTimesRemaining ??= _expirationTimes!;
      _expirationTimesRemaining = _expirationTimesRemaining! - 1;
    }
  }

  /// Returns the key exchange algorithm for this implementation.
  KeyExchangeAlgorithm get algorithm => _algorithm;

  /// Returns the expiration date, if any.
  @override
  DateTime? get expirationDate => _expirationDate;

  /// Returns the initial expiration times limit, if any.
  @override
  int? get expirationTimes => _expirationTimes;

  /// Returns the remaining expiration times, if any.
  @override
  int? get expirationTimesRemaining => _expirationTimesRemaining;
}