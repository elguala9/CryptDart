// ChaCha20: algoritmo simmetrico non basato su numeri primi
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../../types/crypto_algorithm.dart';
import '../partial/symmetric_cipher_impl.dart';

typedef InputChaCha20Cipher = ({
  String key,
  DateTime? expirationDate,
  Uint8List nonce,
});

class ChaCha20Cipher extends SymmetricCipher {
  final Uint8List nonce;

  ChaCha20Cipher(InputChaCha20Cipher input)
      : nonce = input.nonce,
        super((
          algorithm: CryptoAlgorithm.CHACHA20,
          expirationDate: input.expirationDate,
          key: input.key,
        ));

  /// Generates a random 256-bit ChaCha20 key as a hex string
  static String generateKey() {
    final rnd = SecureRandom('AES/CTR/AUTO-SEED-PRNG');
    rnd.seed(KeyParameter(Uint8List.fromList(List.generate(32, (_) => DateTime.now().microsecond % 256))));
    final key = rnd.nextBytes(32); // 256 bits
    return key.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  @override
  List<int> encrypt(List<int> data) {
    final keyBytes = Uint8List.fromList(key.codeUnits);
    final params = ParametersWithIV(KeyParameter(keyBytes), nonce);
    final cipher = ChaCha20Engine();
    cipher.init(true, params);
    return cipher.process(Uint8List.fromList(data));
  }

  @override
  List<int> decrypt(List<int> data) {
    final keyBytes = Uint8List.fromList(key.codeUnits);
    final params = ParametersWithIV(KeyParameter(keyBytes), nonce);
    final cipher = ChaCha20Engine();
    cipher.init(false, params);
    return cipher.process(Uint8List.fromList(data));
  }
}