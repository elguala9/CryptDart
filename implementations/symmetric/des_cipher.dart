// DES/TripleDES: algoritmo simmetrico non basato su numeri primi
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../../types/crypto_algorithm.dart';
import '../partial/symmetric_cipher_impl.dart';

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
    final rnd = SecureRandom('AES/CTR/AUTO-SEED-PRNG');
    rnd.seed(KeyParameter(Uint8List.fromList(List.generate(24, (_) => DateTime.now().microsecond % 256))));
    final key = rnd.nextBytes(24); // 192 bits
    return key.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  @override
  List<int> encrypt(List<int> data) {
    final keyBytes = Uint8List.fromList(key.codeUnits);
    final cipher = DESedeEngine();
    cipher.init(true, KeyParameter(keyBytes));
    return cipher.process(Uint8List.fromList(data));
  }

  @override
  List<int> decrypt(List<int> data) {
    final keyBytes = Uint8List.fromList(key.codeUnits);
    final cipher = DESedeEngine();
    cipher.init(false, KeyParameter(keyBytes));
    return cipher.process(Uint8List.fromList(data));
  }
}