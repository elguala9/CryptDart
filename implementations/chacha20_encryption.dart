import 'package:pointycastle/export.dart';
import 'partial/symmetric_encryption_impl.dart';
import '../types/crypto_algorithm.dart';

class ChaCha20Encryption extends SymmetricEncryption {
  ChaCha20Encryption({required String key, required DateTime expirationDate})
      : super(
          algorithm: CryptoAlgorithm.CHACHA20,
          expirationDate: expirationDate,
          key: key,
        );

  @override
  List<int> encrypt(List<int> data) {
    // Implementazione base, serve nonce e setup completo
    throw UnimplementedError('ChaCha20 richiede nonce e setup completo');
  }

  @override
  List<int> decrypt(List<int> data) {
    throw UnimplementedError('ChaCha20 richiede nonce e setup completo');
  }
}
