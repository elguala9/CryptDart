import '../../interfaces/i_asimmetric.dart';
import '../../types/crypto_algorithm.dart';
import 'sign_impl.dart';

typedef InputAsymmetricSign = ({
  CryptoAlgorithm algorithm,
  DateTime? expirationDate,
  String publicKey,
  String privateKey,
});

abstract class AsymmetricSign extends Sign implements IAsymmetricSign {
  final String publicKey;
  final String privateKey;

  AsymmetricSign(InputAsymmetricSign input)
      : publicKey = input.publicKey,
        privateKey = input.privateKey,
        super((algorithm: input.algorithm, expirationDate: input.expirationDate));
}
