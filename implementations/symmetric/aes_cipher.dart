// AES: algoritmo simmetrico non basato su numeri primi
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../../types/crypto_algorithm.dart';
import '../partial/symmetric_cipher_impl.dart';
import '../../utils/crypto_utils.dart';

typedef InputAESCipher = ({
  String key,
  DateTime? expirationDate,
});

class AESCipher extends SymmetricCipher {
  AESCipher(InputAESCipher input)
      : super((
          algorithm: CryptoAlgorithm.AES,
          expirationDate: input.expirationDate,
          key: input.key,
        ));


  /// Generates a random 256-bit AES key as a hex string
  static String generateKey() {
    return SymmetricKeyUtils.generateKey(bitLength: 256);
  }

  @override
  List<int> encrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.stringKeyToBytes(key);
    final cipher = AESEngine();
    cipher.init(true, KeyParameter(keyBytes));
    return cipher.process(Uint8List.fromList(data));
  }

  @override
  List<int> decrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.stringKeyToBytes(key);
    final cipher = AESEngine();
    cipher.init(false, KeyParameter(keyBytes));
    return cipher.process(Uint8List.fromList(data));
  }
}