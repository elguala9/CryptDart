import 'package:test/test.dart';
import '../lib/implementations/symmetric/aes_cipher.dart';
import '../lib/implementations/symmetric/des_cipher.dart';
import '../lib/implementations/symmetric/chacha20_cipher.dart';
import 'dart:typed_data';
import '../lib/types/crypto_algorithm.dart';

Uint8List padToBlockSize(List<int> data, int blockSize) {
  final padLen = blockSize - (data.length % blockSize);
  return Uint8List.fromList([...data, ...List.filled(padLen, padLen)]);
}

List<int> unpad(Uint8List data) {
  final padLen = data.last;
  if (padLen <= 0 || padLen > data.length) return data;
  return data.sublist(0, data.length - padLen);
}

void main() {
  group('SymmetricCipher', () {
    test('AES encrypt/decrypt', () {
      final cipher = AESCipher((
        parent: (
          key: '1234567890123456',
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.AES,
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      final padded = padToBlockSize(data, 16);
      final encrypted = cipher.encrypt(padded);
      final decrypted = cipher.decrypt(encrypted);
      expect(unpad(Uint8List.fromList(decrypted)), equals(data));
      expect(cipher.algorithm, equals(CryptoAlgorithm.AES));
    });
    test('DES encrypt/decrypt', () {
      final cipher = DESCipher((
        parent: (
          key: '1234567890123456',
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.DES,
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final data = [10, 20, 30, 40, 50, 60, 70, 80];
      final padded = padToBlockSize(data, 8);
      final encrypted = cipher.encrypt(padded);
      final decrypted = cipher.decrypt(encrypted);
      expect(unpad(Uint8List.fromList(decrypted)), equals(data));
      expect(cipher.algorithm, equals(CryptoAlgorithm.DES));
    });
    test('ChaCha20 encrypt/decrypt', () {
      final nonce = Uint8List.fromList(List<int>.generate(8, (i) => i));
      final expirationDate = DateTime.now().add(Duration(days: 1));
      final cipher = ChaCha20Cipher((
        nonce: nonce,
        parent: (
          key: '12345678901234567890123456789012',
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.CHACHA20,
              expirationDate: expirationDate,
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final data = [100, 101, 102, 103, 104, 105, 106, 107];
      final encrypted = cipher.encrypt(data);
      final decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(data));
      expect(cipher.algorithm, equals(CryptoAlgorithm.CHACHA20));
    });
    test('AES encrypt/decrypt without expirationDate', () {
      final cipher = AESCipher((
        parent: (
          key: '1234567890123456',
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.AES,
              expirationDate: null,
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      final padded = padToBlockSize(data, 16);
      final encrypted = cipher.encrypt(padded);
      final decrypted = cipher.decrypt(encrypted);
      expect(unpad(Uint8List.fromList(decrypted)), equals(data));
      expect(cipher.isExpired(), isTrue);
    });
    test('DES encrypt/decrypt without expirationDate', () {
      final cipher = DESCipher((
        parent: (
          key: '1234567890123456',
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.DES,
              expirationDate: null,
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final data = [10, 20, 30, 40, 50, 60, 70, 80];
      final padded = padToBlockSize(data, 8);
      final encrypted = cipher.encrypt(padded);
      final decrypted = cipher.decrypt(encrypted);
      expect(unpad(Uint8List.fromList(decrypted)), equals(data));
      expect(cipher.isExpired(), isTrue);
    });
    test('ChaCha20 encrypt/decrypt without expirationDate', () {
      final nonce = Uint8List.fromList(List<int>.generate(8, (i) => i));
      final cipher = ChaCha20Cipher((
        nonce: nonce,
        parent: (
          key: '12345678901234567890123456789012',
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.CHACHA20,
              expirationDate: null,
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final data = [100, 101, 102, 103, 104, 105, 106, 107];
      final encrypted = cipher.encrypt(data);
      final decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(data));
      expect(cipher.isExpired(), isTrue);
    });
  });
}
