import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/types/crypto_algorithm.dart';
import 'package:cryptdart/interfaces/i_expiration.dart';
import 'package:meta/meta.dart';

/// Input parameters for [ExpirationBase] constructor.
@immutable
class InputExpirationBase {
  final DateTime? expirationDate;
  final int? expirationTimes;

  const InputExpirationBase({
    this.expirationDate,
    this.expirationTimes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputExpirationBase &&
          runtimeType == other.runtimeType &&
          expirationDate == other.expirationDate &&
          expirationTimes == other.expirationTimes;

  @override
  int get hashCode => expirationDate.hashCode ^ expirationTimes.hashCode;

  @override
  String toString() =>
      'InputExpirationBase(expirationDate: $expirationDate, expirationTimes: $expirationTimes)';
}

/// Base class for expiration logic in cryptographic objects.
/// Implements [IExpiration] and manages expiration date, usage limits, and algorithm.
@includeInBarrelFile
abstract class ExpirationBase implements IExpiration {
  final DateTime? _expirationDate;
  final int? _expirationTimes;
  int? _expirationTimesRemaining;

  /// Constructs an [ExpirationBase] with the given input parameters.
  ExpirationBase(InputExpirationBase input)
      : _expirationDate = input.expirationDate,
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
  void incrementUse() {
    if (_expirationTimes != null) {
      _expirationTimesRemaining ??= _expirationTimes!;
      _expirationTimesRemaining = _expirationTimesRemaining! - 1;
    }
  }
  @override
  DateTime? get expirationDate => _expirationDate;

  @override
  int? get expirationTimes => _expirationTimes;

  @override
  int? get expirationTimesRemaining => _expirationTimesRemaining;

  @override
  CryptoAlgorithm get algorithm;
}
