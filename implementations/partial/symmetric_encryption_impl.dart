import '../../interfaces/i_shsp_simmetric_enc.dart';
import '../../types/crypto_algorithm.dart';
import 'encryption_impl.dart';

abstract class SymmetricCipher extends Cipher implements ISimmetricCipher {
  final String _key;
  final DateTime? expirationDate;

  SymmetricCipher({
    required CryptoAlgorithm algorithm,
    this.expirationDate,
    required String key,
  }) : _key = key,
       super(algorithm: algorithm, expirationDate: expirationDate);

  @override
  String get key => _key;


}
