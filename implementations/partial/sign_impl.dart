import '../../interfaces/i_sign.dart';
import '../../types/crypto_algorithm.dart';

typedef InputSign = ({
  CryptoAlgorithm algorithm,
  DateTime? expirationDate,
}); 

abstract class Sign implements ISign {
  final CryptoAlgorithm _algorithm;
  final DateTime? _expirationDate;

  Sign(InputSign input)
      : _algorithm = input.algorithm,
        _expirationDate = input.expirationDate;

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
