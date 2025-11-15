import '../../interfaces/i_shsp_asimmetric_enc.dart';
import '../../types/crypto_algorithm.dart';
import 'encryption_impl.dart';

abstract class AsymmetricCipher extends Cipher implements IAsymmetricCipher {
  final String publicKey;
  final String privateKey;
  final DateTime? expirationDate;

  AsymmetricCipher({
    required CryptoAlgorithm algorithm,
    this.expirationDate,
    required this.publicKey,
    required this.privateKey,
  }) : super(algorithm: algorithm, expirationDate: expirationDate);
}
