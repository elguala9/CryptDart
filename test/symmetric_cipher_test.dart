import 'package:test/test.dart';
import 'package:cryptdart/implementations/symmetric/aes_cipher.dart';
import 'package:cryptdart/implementations/symmetric/des_cipher.dart';
import 'package:cryptdart/implementations/symmetric/chacha20_cipher.dart';
import 'dart:typed_data';
import 'package:cryptdart/types/crypto_algorithm.dart';

void main() {
  group('SymmetricCipher', () {
    test('AES encrypt/decrypt', () {
      final cipher = AESCipher((
        parent: (
          key: AESCipher.generateKey(), // Use generated hex key
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.aes,
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      final encrypted = cipher.encrypt(data); // No manual padding needed
      final decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(data)); // No manual unpadding needed
      expect(cipher.algorithm, equals(CryptoAlgorithm.aes));
    });
    test('DES encrypt/decrypt', () {
      final cipher = DESCipher((
        parent: (
          key: DESCipher.generateKey(), // Use generated hex key
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.des,
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final data = [10, 20, 30, 40, 50, 60, 70, 80];
      final encrypted = cipher.encrypt(data); // No manual padding needed
      final decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(data)); // No manual unpadding needed
      expect(cipher.algorithm, equals(CryptoAlgorithm.des));
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
              algorithm: CryptoAlgorithm.chacha20,
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
      expect(cipher.algorithm, equals(CryptoAlgorithm.chacha20));
    });
    test('AES encrypt/decrypt without expirationDate', () {
      final cipher = AESCipher((
        parent: (
          key: AESCipher.generateKey(),
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.aes,
              expirationDate: null,
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      final encrypted = cipher.encrypt(data);
      final decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(data));
      expect(cipher.isExpired(), isTrue);
    });
    test('DES encrypt/decrypt without expirationDate', () {
      final cipher = DESCipher((
        parent: (
          key: DESCipher.generateKey(),
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.des,
              expirationDate: null,
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final data = [10, 20, 30, 40, 50, 60, 70, 80];
      final encrypted = cipher.encrypt(data);
      final decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(data));
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
              algorithm: CryptoAlgorithm.chacha20,
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
