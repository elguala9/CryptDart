import '../../interfaces/i_asimmetric.dart';
import '../../types/crypto_algorithm.dart';
import 'cipher_impl.dart';

typedef InputAsymmetricCipher = ({
  CryptoAlgorithm algorithm,
  DateTime? expirationDate,
  String publicKey,
  String? privateKey,
});

abstract class AsymmetricCipher extends Cipher implements IAsymmetricCipher {
  final String publicKey;
  final String? privateKey;

  AsymmetricCipher(InputAsymmetricCipher input)
      : publicKey = input.publicKey,
        privateKey = input.privateKey,
        super((algorithm: input.algorithm, expirationDate: input.expirationDate));
}
