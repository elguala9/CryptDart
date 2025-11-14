import 'package:pointycastle/export.dart';
import 'partial/asymmetric_encryption_impl.dart';
import '../types/crypto_algorithm.dart';

class RSAEncryption extends AsymmetricEncryption {
  RSAEncryption({
    required String publicKey,
    required String privateKey,
    required DateTime expirationDate,
  }) : super(
          algorithm: CryptoAlgorithm.RSA,
          expirationDate: expirationDate,
          publicKey: publicKey,
          privateKey: privateKey,
        );

  @override
  List<int> encrypt(List<int> data) {
    // Implementazione base, serve setup chiavi
    throw UnimplementedError('RSA richiede setup chiavi PointyCastle');
  }

  @override
  List<int> decrypt(List<int> data) {
    throw UnimplementedError('RSA richiede setup chiavi PointyCastle');
  }
}
