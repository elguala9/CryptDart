import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/types/key_exchange_algorithm.dart';
import 'package:cryptdart/interfaces/i_base_expiration.dart';
import 'package:meta/meta.dart';

/// Input parameters for [KeyExchangeBase] constructor.
@immutable
class InputKeyExchangeBase {
  final KeyExchangeAlgorithm algorithm;
  final DateTime? expirationDate;
  final int? expirationTimes;

  const InputKeyExchangeBase({
    required this.algorithm,
    this.expirationDate,
    this.expirationTimes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputKeyExchangeBase &&
          runtimeType == other.runtimeType &&
          algorithm == other.algorithm &&
          expirationDate == other.expirationDate &&
          expirationTimes == other.expirationTimes;

  @override
  int get hashCode =>
      algorithm.hashCode ^ expirationDate.hashCode ^ expirationTimes.hashCode;

  @override
  String toString() =>
      'InputKeyExchangeBase(algorithm: $algorithm, expirationDate: $expirationDate, expirationTimes: $expirationTimes)';
}

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