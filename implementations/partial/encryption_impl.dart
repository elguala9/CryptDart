import '../../interfaces/i_shsp_enc.dart';
import '../../types/crypto_algorithm.dart';

abstract class Cipher implements ICipher {
  final CryptoAlgorithm _algorithm;
  final DateTime? _expirationDate;

  Cipher({required CryptoAlgorithm algorithm, DateTime? expirationDate})
      : _algorithm = algorithm,
        _expirationDate = expirationDate;

  @override
  bool isExpired() {
    if (_expirationDate == null) return true;
    return DateTime.now().isAfter(_expirationDate!);
  }

  @override
  DateTime? get expirationDate => _expirationDate;

  @override
  CryptoAlgorithm get algorithm => _algorithm;
}
