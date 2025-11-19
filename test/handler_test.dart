import 'package:test/test.dart';
import 'dart:typed_data';
import '../lib/implementations/symmetric/aes_cipher.dart';
import '../lib/implementations/handlers/handler_cipher.dart';
import '../lib/implementations/handlers/handler_sign.dart';
import '../lib/implementations/signed_based/hmac_sign.dart';
import '../lib/implementations/asymmetric/prime_based/rsa_cipher.dart';
import '../lib/implementations/signed_based/rsa_signature_cipher.dart';
import '../lib/types/crypto_algorithm.dart';

void main() {
  group('HandlerCipherSymmetric', () {
    Uint8List padToBlockSize(List<int> data, int blockSize) {
      final padLen = blockSize - (data.length % blockSize);
      return Uint8List.fromList([...data, ...List.filled(padLen, padLen)]);
    }

    List<int> unpad(Uint8List data) {
      final padLen = data.last;
      if (padLen <= 0 || padLen > data.length) return data;
      return data.sublist(0, data.length - padLen);
    }

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
      final handler = HandlerCipherSymmetric<AESCipher>(
        (
          initialCrypt: cipher,
          maxCrypts: 5,
          maxExpiredCrypts: 5,
          maxDaysExpiredCrypts: 0,
        ),
      );
      final data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      final padded = padToBlockSize(data, 16);
      final encrypted = handler.encrypt(padded);
      final decrypted = handler.decrypt(encrypted);
      expect(unpad(Uint8List.fromList(decrypted)), equals(data));
    });
  });

  group('HandlerCipherAsymmetric', () {
    test('RSA encrypt/decrypt', () async {
      final keyPair = await RSACipher.generateKeyPair();
      final cipher = RSACipher((
        parent: (
          publicKey: keyPair['publicKey']!,
          privateKey: keyPair['privateKey']!,
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.RSA,
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final handler = HandlerCipherAsymmetric<RSACipher>(
        (
          initialCrypt: cipher,
          maxCrypts: 5,
          maxExpiredCrypts: 5,
          maxDaysExpiredCrypts: 0,
        ),
      );
      final data = [1, 2, 3, 4, 5];
      final encrypted = handler.encrypt(data);
      final decrypted = handler.decrypt(encrypted);
      expect(decrypted, equals(data));
    });
  });

  group('HandlerSignSymmetric', () {
    test('HMAC sign/verify', () {
      final sign = HMACSign((
        parent: (
          key: '1234567890123456',
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.HMAC,
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final handler = HandlerSignSymmetric<HMACSign>(
        (
          initialCrypt: sign,
          maxCrypts: 5,
          maxExpiredCrypts: 5,
          maxDaysExpiredCrypts: 0,
        ),
      );
      final data = [1, 2, 3, 4, 5];
      final signature = handler.sign(data);
      // HMACSign.verify lancia UnimplementedError, quindi usiamo verifyHMAC
      final verified = handler.currentCrypt.verifyHMAC(data, signature);
      expect(verified, isTrue);
    });
  });

  group('HandlerSignAsymmetric', () {
    test('RSA signature sign/verify', () async {
      final keyPair = await RSASignatureCipher.generateKeyPair();
      final sign = RSASignatureCipher((
        parent: (
          publicKey: keyPair['publicKey']!,
          privateKey: keyPair['privateKey']!,
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.RSA_SIGNATURE,
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final handler = HandlerSignAsymmetric<RSASignatureCipher>(
        (
          initialCrypt: sign,
          maxCrypts: 5,
          maxExpiredCrypts: 5,
          maxDaysExpiredCrypts: 0,
        ),
      );
      final data = [1, 2, 3, 4, 5];
      final signature = handler.sign(data);
      // RSASignatureCipher.verify lancia UnimplementedError, quindi usiamo verifySignature
      final verified = handler.currentCrypt.verifySignature(data, signature);
      expect(verified, isTrue);
    });
  });
}
