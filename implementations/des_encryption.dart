import 'dart:typed_data';
import 'package:pointycastle/export.dart';

import '../types/crypto_algorithm.dart';
import 'partial/symmetric_encryption_impl.dart';

class DESEncryption extends SymmetricEncryption {
  DESEncryption({required String key, required DateTime expirationDate})
      : super(
          algorithm: CryptoAlgorithm.DES,
          expirationDate: expirationDate,
          key: key,
        );

  @override
  List<int> encrypt(List<int> data) {
    final keyBytes = Uint8List.fromList(key.codeUnits);
    final cipher = DESedeEngine();
    final params = KeyParameter(keyBytes);
    cipher.init(true, params);
    return cipher.process(Uint8List.fromList(data));
  }

  @override
  List<int> decrypt(List<int> data) {
    final keyBytes = Uint8List.fromList(key.codeUnits);
    final cipher = DESedeEngine();
    final params = KeyParameter(keyBytes);
    cipher.init(false, params);
    return cipher.process(Uint8List.fromList(data));
  }
}
