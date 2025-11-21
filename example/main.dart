

import 'package:cryptdart/cryptdart.dart';
import 'dart:typed_data';




Future<void> main() async {
  // AES Example
  final aesKey = AESCipher.generateKey();
  final aesCipher = AESCipher((
    parent: (
      key: aesKey,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.aes,
          expirationDate: null,
          expirationTimes: null,
        ),
      ),
    ),
  ));
  final aesEncrypted = aesCipher.encrypt([1, 2, 3, 4]);
  final aesDecrypted = aesCipher.decrypt(aesEncrypted);
  print('AES decrypted: $aesDecrypted');

  // DES Example
  final desKey = DESCipher.generateKey();
  final desCipher = DESCipher((
    parent: (
      key: desKey,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.des,
          expirationDate: null,
          expirationTimes: null,
        ),
      ),
    ),
  ));
  final desEncrypted = desCipher.encrypt([1, 2, 3, 4]);
  final desDecrypted = desCipher.decrypt(desEncrypted);
  print('DES decrypted: $desDecrypted');

  // ChaCha20 Example
  final chachaKey = ChaCha20Cipher.generateKey();
  final nonce = Uint8List(8); // Usa un nonce random sicuro in produzione
  final chachaCipher = ChaCha20Cipher((
    parent: (
      key: chachaKey,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.chacha20,
          expirationDate: null,
          expirationTimes: null,
        ),
      ),
    ),
    nonce: nonce,
  ));
  final chachaEncrypted = chachaCipher.encrypt([1, 2, 3, 4]);
  final chachaDecrypted = chachaCipher.decrypt(chachaEncrypted);
  print('ChaCha20 decrypted: $chachaDecrypted');

  // RSA Example
  final rsaKeys = await RSACipher.generateKeyPair();
  final rsaCipher = RSACipher((
    parent: (
      publicKey: rsaKeys['publicKey']!,
      privateKey: rsaKeys['privateKey']!,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.rsa,
          expirationDate: null,
          expirationTimes: null,
        ),
      ),
    ),
  ));
  final rsaEncrypted = rsaCipher.encrypt([1, 2, 3, 4]);
  final rsaDecrypted = rsaCipher.decrypt(rsaEncrypted);
  print('RSA decrypted: $rsaDecrypted');

  // HMAC Example
  final hmacKey = HMACSign.generateKey();
  final hmacSign = HMACSign((
    parent: (
      key: hmacKey,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.hmac,
          expirationDate: null,
          expirationTimes: null,
        ),
      ),
    ),
  ));
  final hmacSignature = hmacSign.sign([1, 2, 3, 4]);
  final hmacVerified = hmacSign.verify([1, 2, 3, 4], hmacSignature);
  print('HMAC verified: $hmacVerified');

  // RSA Signature Example
  final rsaSigKeys = await RSASignatureCipher.generateKeyPair();
  final rsaSign = RSASignatureCipher((
    parent: (
      publicKey: rsaSigKeys['publicKey']!,
      privateKey: rsaSigKeys['privateKey']!,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.rsaSignature,
          expirationDate: null,
          expirationTimes: null,
        ),
      ),
    ),
  ));
  final rsaSignature = rsaSign.sign([1, 2, 3, 4]);
  final rsaSigVerified = rsaSign.verify([1, 2, 3, 4], rsaSignature);
  print('RSA signature verified: $rsaSigVerified');

  // ECDSA Example
  final ecdsaKeys = await ECDSASign.generateKeyPair();
  final ecdsaSign = ECDSASign((
    parent: (
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.ecdsa,
          expirationDate: null,
          expirationTimes: null,
        ),
      ),
      publicKey: ecdsaKeys['publicKey']!,
      privateKey: ecdsaKeys['privateKey']!,
    ),
  ));
  final ecdsaSignature = ecdsaSign.sign([1, 2, 3, 4]);
  final ecdsaVerified = ecdsaSign.verify([1, 2, 3, 4], ecdsaSignature);
  print('ECDSA signature verified: $ecdsaVerified');
}
