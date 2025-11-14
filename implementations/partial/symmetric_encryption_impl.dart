import '../../interfaces/i_shsp_simmetric_enc.dart';
import '../../types/crypto_algorithm.dart';
import 'encryption_impl.dart';

abstract class SymmetricEncryption extends Encryption implements ISimmetricEncryption {
  final String _key;

  SymmetricEncryption({
    required CryptoAlgorithm algorithm,
    required DateTime expirationDate,
    required String key,
  }) : _key = key,
       super(algorithm: algorithm, expirationDate: expirationDate);

  @override
  String get key => _key;


}
