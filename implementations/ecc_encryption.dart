import 'package:pointycastle/export.dart';
import 'partial/asymmetric_encryption_impl.dart';
import '../types/crypto_algorithm.dart';

class ECCEncryption extends AsymmetricEncryption {
  ECCEncryption({
    required String publicKey,
    required String privateKey,
    required DateTime expirationDate,
  }) : super(
          algorithm: CryptoAlgorithm.ECC,
          expirationDate: expirationDate,
          publicKey: publicKey,
          privateKey: privateKey,
        );

  @override
  List<int> encrypt(List<int> data) {
    throw UnimplementedError('ECC richiede setup chiavi PointyCastle');
  }

  @override
  List<int> decrypt(List<int> data) {
    throw UnimplementedError('ECC richiede setup chiavi PointyCastle');
  }
}
