import '../../interfaces/i_cipher.dart';
import '../../types/crypto_algorithm.dart';

typedef InputCipher = ({
  CryptoAlgorithm algorithm,
  DateTime? expirationDate,
}); 

abstract class Cipher implements ICipher {
  final CryptoAlgorithm _algorithm;
  final DateTime? _expirationDate;

    Cipher(InputCipher input)
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
