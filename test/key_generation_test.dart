import 'package:test/test.dart';
import 'package:cryptdart/implementations/symmetric/aes_cipher.dart';
import 'package:cryptdart/implementations/symmetric/des_cipher.dart';
import 'package:cryptdart/implementations/symmetric/chacha20_cipher.dart';
import 'package:cryptdart/implementations/signed_based/hmac_sign.dart';
import 'package:cryptdart/implementations/asymmetric/prime_based/rsa_cipher.dart';
import 'package:cryptdart/implementations/signed_based/rsa_signature_cipher.dart';
import 'package:cryptdart/implementations/partial/symmetric_cipher_impl.dart';
import 'package:cryptdart/implementations/partial/asymmetric_cipher_impl.dart';
import 'package:cryptdart/implementations/partial/symmetric_sign_impl.dart';
import 'package:cryptdart/implementations/partial/asymmetric_sign_impl.dart';
import 'package:cryptdart/implementations/partial/cipher_impl.dart';
import 'package:cryptdart/implementations/partial/sign_impl.dart';
import 'package:cryptdart/implementations/partial/expiration_base.dart';
import 'package:cryptdart/types/crypto_algorithm.dart';
import 'dart:typed_data';

void main() {
  group('Symmetric key generation', () {
    test('AES key generation', () {
      final key = AESCipher.generateKey();
      expect(key.length, 64); // 256 bit in hex
      final cipher = AESCipher(InputAESCipher(
        parent: InputSymmetricCipher(
          key: '1234567890123456',
          parent: InputCipher(
            parent: InputExpirationBase(
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      expect(cipher.algorithm, equals(SymmetricCipherAlgorithmEnum.aes));
    });
    test('DES key generation', () {
      final key = DESCipher.generateKey();
      expect(key.length, 48); // 192 bit in hex
      final cipher = DESCipher(InputDESCipher(
        parent: InputSymmetricCipher(
          key: '1234567890123456',
          parent: InputCipher(
            parent: InputExpirationBase(
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      expect(cipher.algorithm, equals(SymmetricCipherAlgorithmEnum.des));
    });
    test('ChaCha20 key generation', () {
      final key = ChaCha20Cipher.generateKey();
      expect(key.length, 64); // 256 bit in hex
      final nonce = Uint8List.fromList(List<int>.generate(8, (i) => i));
      final expirationDate = DateTime.now().add(Duration(days: 1));
      final cipher = ChaCha20Cipher(InputChaCha20Cipher(
        nonce: nonce,
        parent: InputSymmetricCipher(
          key: '12345678901234567890123456789012',
          parent: InputCipher(
            parent: InputExpirationBase(
              expirationDate: expirationDate,
              expirationTimes: null,
            ),
          ),
        ),
      ));
      expect(cipher.algorithm, equals(SymmetricCipherAlgorithmEnum.chacha20));
    });
    test('HMAC key generation', () {
      final key = HMACSign.generateKey();
      expect(key.length, 64); // 256 bit in hex
      final cipher = HMACSign(InputHMACSign(
        parent: InputSymmetricSign(
          key: '12345678901234567890123456789012',
          parent: InputSign(
            parent: InputExpirationBase(
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      expect(cipher.algorithm, equals(SymmetricSignAlgorithmEnum.hmac));
    });
  });

  group('Asymmetric key pair generation', () {
    test('RSA key pair generation', () async {
      final pair = await RSACipher.generateKeyPair();
      expect(pair['publicKey'], contains('BEGIN PUBLIC KEY'));
      expect(pair['privateKey'], contains('BEGIN PRIVATE KEY'));
      final cipher = RSACipher(InputRSACipher(
        parent: InputAsymmetricCipher(
          publicKey: pair['publicKey']!,
          privateKey: pair['privateKey']!,
          parent: InputCipher(
            parent: InputExpirationBase(
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      expect(cipher.algorithm, equals(AsymmetricCipherAlgorithmEnum.rsa));
    });
    test('RSA Signature key pair generation', () async {
      final pair = await RSASignatureCipher.generateKeyPair();
      expect(pair['publicKey'], contains('BEGIN PUBLIC KEY'));
      expect(pair['privateKey'], contains('BEGIN PRIVATE KEY'));
      final expirationDate = DateTime.now().add(Duration(days: 1));
      final cipher = RSASignatureCipher(InputRSASignatureCipher(
        parent: InputAsymmetricSign(
          publicKey: pair['publicKey']!,
          privateKey: pair['privateKey']!,
          parent: InputSign(
            parent: InputExpirationBase(
              expirationDate: expirationDate,
              expirationTimes: null,
            ),
          ),
        ),
      ));
      expect(cipher.algorithm, equals(AsymmetricSignAlgorithmEnum.rsaSignature));
    });
  });
}
