// ChaCha20: algoritmo simmetrico non basato su numeri primi
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../../../types/crypto_algorithm.dart';
import '../../partial/symmetric_encryption_impl.dart';

class ChaCha20Cipher extends SymmetricCipher {
  final Uint8List nonce;

  ChaCha20Cipher({required String key, DateTime? expirationDate, required this.nonce})
      : super(
          algorithm: CryptoAlgorithm.CHACHA20,
          expirationDate: expirationDate,
          key: key,
        );

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