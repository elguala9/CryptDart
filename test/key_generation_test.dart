import 'package:test/test.dart';
import '../lib/implementations/symmetric/aes_cipher.dart';
import '../lib/implementations/symmetric/des_cipher.dart';
import '../lib/implementations/symmetric/chacha20_cipher.dart';
import '../lib/implementations/signed_based/hmac_sign.dart';
import '../lib/implementations/asymmetric/prime_based/rsa_cipher.dart';
import '../lib/implementations/signed_based/rsa_signature_cipher.dart';
import '../lib/types/crypto_algorithm.dart';
import 'dart:typed_data';

void main() {
  group('Symmetric key generation', () {
    test('AES key generation', () {
      final key = AESCipher.generateKey();
      expect(key.length, 64); // 256 bit in hex
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
      expect(cipher.algorithm, equals(CryptoAlgorithm.AES));
    });
    test('DES key generation', () {
      final key = DESCipher.generateKey();
      expect(key.length, 48); // 192 bit in hex
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
      expect(cipher.algorithm, equals(CryptoAlgorithm.DES));
    });
    test('ChaCha20 key generation', () {
      final key = ChaCha20Cipher.generateKey();
      expect(key.length, 64); // 256 bit in hex
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
      expect(cipher.algorithm, equals(CryptoAlgorithm.CHACHA20));
    });
    test('HMAC key generation', () {
      final key = HMACSign.generateKey();
      expect(key.length, 64); // 256 bit in hex
      final cipher = HMACSign((
        parent: (
          key: '12345678901234567890123456789012',
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.HMAC,
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      expect(cipher.algorithm, equals(CryptoAlgorithm.HMAC));
    });
  });

  group('Asymmetric key pair generation', () {
    test('RSA key pair generation', () async {
      final pair = await RSACipher.generateKeyPair();
      expect(pair['publicKey'], contains('BEGIN PUBLIC KEY'));
      expect(pair['privateKey'], contains('BEGIN PRIVATE KEY'));
      final cipher = RSACipher((
        parent: (
          publicKey: pair['publicKey']!,
          privateKey: pair['privateKey']!,
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.RSA,
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      expect(cipher.algorithm, equals(CryptoAlgorithm.RSA));
    });
    test('RSA Signature key pair generation', () async {
      final pair = await RSASignatureCipher.generateKeyPair();
      expect(pair['publicKey'], contains('BEGIN PUBLIC KEY'));
      expect(pair['privateKey'], contains('BEGIN PRIVATE KEY'));
        final expirationDate = DateTime.now().add(Duration(days: 1));
        final cipher = RSASignatureCipher((
          parent: (
            publicKey: pair['publicKey']!,
            privateKey: pair['privateKey']!,
            parent: (
              parent: (
                algorithm: CryptoAlgorithm.RSA_SIGNATURE,
                expirationDate: expirationDate,
                expirationTimes: null,
              ),
            ),
          ),
        ));
      expect(cipher.algorithm, equals(CryptoAlgorithm.RSA_SIGNATURE));
    });

  });
}
