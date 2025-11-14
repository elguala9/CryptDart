import '../../interfaces/i_shsp_enc.dart';
import '../../types/crypto_algorithm.dart';

abstract class Encryption implements IEncryption {
  final CryptoAlgorithm _algorithm;
  final DateTime _expirationDate;

  Encryption({required CryptoAlgorithm algorithm, required DateTime expirationDate})
      : _algorithm = algorithm,
        _expirationDate = expirationDate;

  @override
  bool isExpired() {
    return DateTime.now().isAfter(_expirationDate);
  }

  @override
  DateTime get expirationDate => _expirationDate;

  @override
  CryptoAlgorithm get algorithm => _algorithm;
}
