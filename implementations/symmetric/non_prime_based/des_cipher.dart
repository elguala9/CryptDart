// DES/TripleDES: algoritmo simmetrico non basato su numeri primi
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../../../types/crypto_algorithm.dart';
import '../../partial/symmetric_encryption_impl.dart';

class DESCipher extends SymmetricCipher {
  DESCipher({required String key, DateTime? expirationDate})
      : super(
          algorithm: CryptoAlgorithm.DES,
          expirationDate: expirationDate,
          key: key,
        );

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