// DES/TripleDES: algoritmo simmetrico non basato su numeri primi
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../../types/crypto_algorithm.dart';
import '../partial/symmetric_cipher_impl.dart';
import '../../utils/crypto_utils.dart';

typedef InputDESCipher = ({
  String key,
  DateTime? expirationDate,
});

class DESCipher extends SymmetricCipher {
  DESCipher(InputDESCipher input)
      : super((
          algorithm: CryptoAlgorithm.DES,
          expirationDate: input.expirationDate,
          key: input.key,
        ));


  /// Generates a random 192-bit TripleDES key as a hex string
  static String generateKey() {
    return SymmetricKeyUtils.generateKey(bitLength: 192);
  }

  @override
  List<int> encrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.stringKeyToBytes(key);
    final cipher = DESedeEngine();
    cipher.init(true, KeyParameter(keyBytes));
    return cipher.process(Uint8List.fromList(data));
  }

  @override
  List<int> decrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.stringKeyToBytes(key);
    final cipher = DESedeEngine();
    cipher.init(false, KeyParameter(keyBytes));
    return cipher.process(Uint8List.fromList(data));
  }
}