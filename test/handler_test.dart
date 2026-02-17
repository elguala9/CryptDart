import 'package:test/test.dart';
import 'package:cryptdart/implementations/symmetric/aes_cipher.dart';
import 'package:cryptdart/implementations/handlers/handler_cipher.dart';
import 'package:cryptdart/implementations/handlers/handler_sign.dart';
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
import 'package:cryptdart/implementations/handlers/handler.dart';

void main() {
  group('HandlerCipherSymmetric', () {
    test('AES encrypt/decrypt', () {
      final cipher = AESCipher(InputAESCipher(
        parent: InputSymmetricCipher(
          key: AESCipher.generateKey(),
          parent: InputCipher(
            parent: InputExpirationBase(
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final handler = HandlerCipherSymmetric(
        InputHandler(
          initialCrypt: cipher,
          maxCrypts: 5,
          maxExpiredCrypts: 5,
          maxDaysExpiredCrypts: 0,
        ),
      );
      final data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      final encrypted = handler.encrypt(data);
      final decrypted = handler.decrypt(encrypted);
      expect(decrypted, equals(data));
    });
  });

  group('HandlerCipherAsymmetric', () {
    test('RSA encrypt/decrypt', () async {
      final keyPair = await RSACipher.generateKeyPair();
      final cipher = RSACipher(InputRSACipher(
        parent: InputAsymmetricCipher(
          publicKey: keyPair['publicKey']!,
          privateKey: keyPair['privateKey']!,
          parent: InputCipher(
            parent: InputExpirationBase(
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final handler = HandlerCipherAsymmetric(
        InputHandler(
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
      final sign = HMACSign(InputHMACSign(
        parent: InputSymmetricSign(
          key: '1234567890123456',
          parent: InputSign(
            parent: InputExpirationBase(
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final handler = HandlerSignSymmetric(
        InputHandler(
          initialCrypt: sign,
          maxCrypts: 5,
          maxExpiredCrypts: 5,
          maxDaysExpiredCrypts: 0,
        ),
      );
      final data = [1, 2, 3, 4, 5];
      final signature = handler.sign(data);
      // HMACSign.verify lancia UnimplementedError, quindi usiamo verifyHMAC
      final verified = handler.currentCrypt.verify(data, signature);
      expect(verified, isTrue);
    });
  });

  group('HandlerSignAsymmetric', () {
    test('RSA signature sign/verify', () async {
      final keyPair = await RSASignatureCipher.generateKeyPair();
      final sign = RSASignatureCipher(InputRSASignatureCipher(
        parent: InputAsymmetricSign(
          publicKey: keyPair['publicKey']!,
          privateKey: keyPair['privateKey']!,
          parent: InputSign(
            parent: InputExpirationBase(
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final handler = HandlerSignAsymmetric(
        InputHandler(
          initialCrypt: sign,
          maxCrypts: 5,
          maxExpiredCrypts: 5,
          maxDaysExpiredCrypts: 0,
        ),
      );
      final data = [1, 2, 3, 4, 5];
      final signature = handler.sign(data);
      // RSASignatureCipher.verify lancia UnimplementedError, quindi usiamo verifySignature
      final verified = handler.currentCrypt.verify(data, signature);
      expect(verified, isTrue);
    });
  });
}
