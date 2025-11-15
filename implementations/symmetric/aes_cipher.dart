// AES: algoritmo simmetrico non basato su numeri primi
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../../types/crypto_algorithm.dart';
import '../partial/symmetric_cipher_impl.dart';

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
    final rnd = SecureRandom('AES/CTR/AUTO-SEED-PRNG');
    rnd.seed(KeyParameter(Uint8List.fromList(List.generate(32, (_) => DateTime.now().microsecond % 256))));
    final key = rnd.nextBytes(32); // 256 bits
    return key.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  @override
  List<int> encrypt(List<int> data) {
    final keyBytes = Uint8List.fromList(key.codeUnits);
    final cipher = AESEngine();
    cipher.init(true, KeyParameter(keyBytes));
    return cipher.process(Uint8List.fromList(data));
  }

  @override
  List<int> decrypt(List<int> data) {
    final keyBytes = Uint8List.fromList(key.codeUnits);
    final cipher = AESEngine();
    cipher.init(false, KeyParameter(keyBytes));
    return cipher.process(Uint8List.fromList(data));
  }
}