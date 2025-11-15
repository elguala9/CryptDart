// AES: algoritmo simmetrico non basato su numeri primi
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../../../types/crypto_algorithm.dart';
import '../../partial/symmetric_encryption_impl.dart';

class AESCipher extends SymmetricCipher {
  AESCipher({required String key, DateTime? expirationDate})
      : super(
          algorithm: CryptoAlgorithm.AES,
          expirationDate: expirationDate,
          key: key,
        );

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